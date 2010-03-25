asds
require 'neo4j/extensions/meta_info'

module DingDealer
  module Neo4jw

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
          extend  SingletonMethods
          include ::Neo4j::MetaInfo             if neo_node_env.db.meta_info
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
            db  dingsl_accessor(:meta_info => false, :validations => false)
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
        def load_node(neo_id)
          ::Neo4j.load_node(neo_id)
        end

        # loads an neo node by it's node id,
        # raises if this does not is an instance of the calling class
        #
        # @param [Fixnum] neo_id the neo node id
        # @return [NeoNodeInstance] an instance of a neo node
        # @example loading a node
        #   "Concept.load_node!(22)" #=> concept instance
        def load_node!(neo_id)
          node = load_node(neo_id)
          raise NotFoundException unless node.is_a?(self)
          node
        end

        def to_a
          all.nodes.to_a
        end

        # not sure if this is the best way
        def first
          all.nodes.first
        end

        def find_first(query = nil, &block)
          find(query, &block).first
        end

        def find_first!(query=nil, &block)
          find_first(query, &block) ||
            raise(NotFoundException.new("can't find #{self.name} with query #{query.inspect}"))
        end

        def short_name
          model_name.split('::').last.humanize
        end

        # overwriting Neo4j::NodeMixin.value_object
        def value_object
          @value_class ||= if neo_node_env.db.validations
            value_klass = create_value_class
            value_klass.send(:include, Node::Validations)
            value_klass.send(:include, ValueObjectExtensions::Validations)
            value_klass.send(:extend,  ValueObjectExtensions::ClassMethods)
            value_klass
          else
            value_klass = create_value_class
            value_klass.send(:include, Node::ValidationStubs)
            value_klass.send(:extend,  ValueObjectExtensions::ClassMethods)
            value_klass.send(:include, ValueObjectExtensions::InstanceMethods)
            value_klass.send(:include, "#{model_name}::SharedMethods".constantize) if const_defined?(:SharedMethods)
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
        def init_node(*args)
          if (properties = args.first).is_a?(Hash)
            update(properties)
          end
          set_default_values
        end

        def id
          neo_id
        end

        def to_param
          "#{id}-#{name.parameterize}"
        end

        def <=>(other)
          neo_id <=> other.neo_id
        end

        def update!(hash)
          if hash.keys.all?{ |key| property?(key) }
            update(hash)
          else
            raise NoMethodError.new("#{self.name} does not have all of this properties #{hash.keys.join(',')}")
          end
        end

        # rails needs this for formbuilders an more
        def new_record?
          false
        end


      protected

        def set_default_values
          neo_node_env.defaults.to_hash.each do |property, value|
            self[property] = value if self[property].blank?
          end
        end

      end



      module ValueObjectExtensions
        module ClassMethods
          def short_name
            model_name.split('::').last.humanize
          end
        end

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
          attr_accessor :new_record
          attr_writer :id

          def to_param
            name.blank? ? id.to_s : "#{id}-#{name.parameterize}"
          end

          # overwriting from Neo Mixin
          def new_record?
            @new_record ? @new_record : ! defined?(@_updated)
          end

          def id
            @id
          end

        end
      end

    end
  end
end