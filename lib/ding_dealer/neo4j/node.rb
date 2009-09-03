# require 'ostruct'

module DingDealer
  module Neo4j

    module Node
      class NotFoundException < StandardError; end
      class InvalidRecord < StandardError; end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def is_a_neo_node(&block)
          unless respond_to?(:neo_node_env)
            Dsl.new(self).evaluate_dsl(&block)
          else
            neo_node_env.dsl.evaluate_dsl(&block)
          end

          include ::Neo4j::NodeMixin
          include ::Neo4j::DynamicAccessorMixin if neo_node_env.db.dynamic_properties
          extend  SingletonMethods
          include Node::MetaInfoExtensions      if neo_node_env.db.meta_info
          include InstanceMethods
          include Node::Validations             if neo_node_env.db.validations
          include Node::ValidationStubs         unless neo_node_env.db.validations
        end
      end


      class Dsl
        def initialize(node_klass)
          @node_klass = node_klass
          setup_dsl
        end

        def setup_dsl
          @node_klass.class_eval do
            class_inheritable_accessor :neo_node_env
          end

          @node_klass.neo_node_env = dingsl_accessor do
            db  dingsl_accessor(:meta_info => false, :dynamic_properties => false, :validations => false)
            defaults DingDealer::OpenStruct.new
            acl dingsl_accessor(:default_visibility => false)
            dsl
          end

          @node_klass.neo_node_env.dsl = self
        end

        def evaluate_dsl(&block)
          @node_klass.neo_node_env.instance_eval(&block) if block_given?
          self
        end
      end



      module SingletonMethods
        def load(neo_node_id)
          ::Neo4j::Transaction.run do
            ::Neo4j.send(:load, neo_node_id)
          end
        end

        def load!(neo_node_id)
          node = load(neo_node_id)
          raise NotFoundException unless node.is_a?(self)
          node
        end

        def property_names
          properties_info.keys
        end

        def properties?(*properties)
          properties.empty? ? false : properties.flatten.all?{ |property| property?(property) }
        end

        def nodes
          ::Neo4j::Transaction.run { all.nodes.to_a }
        end

        # not sure if this is the best way
        def first_node
          all.nodes.min
        end

        # not sure if this is the best way
        def last_node
          all.nodes.max
        end

        def find_first(query=nil, &block)
          matches = find(query, &block)
          matches.size > 0 ? ::Neo4j::Transaction.run{ matches[0] } : nil
        end

        def find_first!(query=nil, &block)
          find_first(query, &block) ||
            raise(NotFoundException.new("can't find #{self.name} with query #{query.inspect}"))
        end

        # overwriting Neo4j::NodeMixin.value_object
        def value_object
          @value_class ||= if neo_node_env.db.validations
            value_klass = create_value_class
            value_klass.send(:include, Node::Validations)
            value_klass.send(:include, ValueObjectExtensions::Validations)
            value_klass
          else
            value_klass = create_value_class
            value_klass.send(:include, Node::ValidationStubs)
            value_klass
          end
        end

        def new_with_validations(attributes_hash)
          # need to use block here to roll back node creation if it is invalid
          update_with_validations(attributes_hash, attributes_hash, :new_record_for_value_object => true){ new }
        end

        def update_with_validations(node_or_attributes_hash, attributes_hash, options = {})
          options = options.reverse_merge(:new_record_for_value_object => false)
          begin
            ::Neo4j::Transaction.run do
              if block_given?
                attributes_hash = node_or_attributes_hash
                node = yield
              else
                node = node_or_attributes_hash
              end

              node.update(attributes_hash)

              unless node.valid?
                raise InvalidRecord.new( invalid_node_to_invalid_value_object(node, options[:new_record_for_value_object]) )
              end
              return node
            end
          rescue InvalidRecord => invalid_value_object_exception
            return invalid_value_object_exception.message # return value_object with errors
          end
        end


        private

        def invalid_node_to_invalid_value_object(node, new_record_for_value_object)
          node.errors.instance_variable_set(:@base, nil)
          invalid_value_object, invalid_value_object.errors = node.value_object, node.errors.dup
          invalid_value_object.extend(ValueObjectExtensions::InstanceMethods) # need to extend here to overwrite #new_record?
          if new_record_for_value_object
            invalid_value_object.new_record = true
          else
            invalid_value_object.id = node.id
          end
          invalid_value_object
        end

        # def load_by_guid!(guid)
        #   decoded = DingDealer::Guid.decode_to_hash(guid)
        #   node = load(decoded[:i].to_i)
        #   node = load(5)
        #   if node.created_at.strftime('%Y%m%d%H%M%S') != decoded[:t] || node.class.name != decoded[:c]
        #     raise DingDealer::Neo4j::NotFoundException
        #   end
        #   node
        # end
      end



      module InstanceMethods
        # overwrite in super to allow hash properties in arguments
        #  p = Person.new(:name => 'peter', :age => 20)
        def initialize(*args)
          @errors = ActiveRecord::Errors.new(self) if neo_node_env.db.validations
          if (properties = args.first).is_a?(Hash)
            super
            update(properties)
          else
            super#(*args)
          end
          set_default_values
        end

        def id
          neo_node_id
        end

        def to_param
          "#{id}-#{name.parameterize}"
        end

        def <=>(other)
          neo_node_id <=> other.neo_node_id
        end

        def update!(hash)
          if hash.keys.all?{ |key| property?(key) }
            ::Neo4j::Transaction.run do
              update(hash)
            end
          else
            raise NoMethodError.new("#{self.name} does not have all of this properties #{hash.keys.join(',')}")
          end
        end

        def new_record?
          false
        end

        protected

        def set_default_values
          neo_node_env.defaults.to_hash.each do |property, value|
            set_property(property, value) if send(property).blank?
          end
        end

      end



      module ValueObjectExtensions
        module Validations
          def initialize(*args)
            @errors = ActiveRecord::Errors.new(self)
            super
          end

          # oberwriting AR:Validations#valid?
          def valid?
            @errors.empty?
          end
        end


        module InstanceMethods
          attr_accessor :id, :new_record

          def to_param
            name.blank? ? id.to_s : "#{id}-#{name.parameterize}"
          end

          # overwriting from Neo Mixin
          def new_record?
            @new_record ? @new_record : ! defined?(@_updated)
          end
        end
      end

    end
  end
end