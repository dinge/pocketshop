module RoboRails
  module Neo4j

    class NotFoundException < StandardError; end

    module Node

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def is_a_neo_node
          cattr_accessor :db, :acl
          self.db = Struct.new(:meta_info, :dynamic_properties, :validations).new
          self.acl = Struct.new(:default_visibility).new
          yield if block_given?

          include ::Neo4j::NodeMixin
          include ::Neo4j::DynamicAccessorMixin if db.dynamic_properties
          extend  SingletonMethods
          include MetaInfoExtensions            if db.meta_info
          include InstanceMethods
          include NodeValidations               if db.validations
        end
      end


      module SingletonMethods
        def l(neo_node_id)
          node = ::Neo4j.load(neo_node_id)
          raise RoboRails::Neo4j::NotFoundException unless node.is_a?(self)
          node
        end

        # overwriting something from a parent class, seems to work ..
        alias :load :l

        def property_names
          properties_info.keys
        end

        def all_nodes
          all.nodes
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
          matches.size > 0 ? matches[0] : nil
        end

        def find_first!(query=nil, &block)
          find_first(query, &block) ||
            raise(RoboRails::Neo4j::NotFoundException.new("can't find #{self.name} with query #{query.inspect}"))
        end

        # def load_by_guid!(guid)
        #   decoded = DingDealer::Guid.decode_to_hash(guid)
        #   node = load(decoded[:i].to_i)
        #   node = load(5)
        #   if node.created_at.strftime('%Y%m%d%H%M%S') != decoded[:t] || node.class.name != decoded[:c]
        #     raise RoboRails::Neo4j::NotFoundException
        #   end
        #   node
        # end
      end


      module InstanceMethods
        # overwrite in super to allow hash properties in arguments
        #  p = Person.new(:name => 'peter', :age => 20)
        def initialize(*args)
          @errors = ActiveRecord::Errors.new(self) if self.class.db.validations
          if (properties = args.first).is_a?(Hash)
            super
            update(properties)
          else
            super(*args)
          end
        end

        def id
          neo_node_id
        end

        def to_param
          "#{id}-#{name}"
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


        # def to_guid
        #   DingDealer::Guid.encode(
        #     :i => id,
        #     :t => created_at.strftime('%Y%m%d%H%M%S'),
        #     :c => self.class.name,
        #     :u => 'x@xxx.de',
        #     :r => rand(9999999) )
        # end

        # alias :to_param :to_guid
      end



      module MetaInfoExtensions
        def self.included(base)
          base.class_eval do
            property :created_at, :type => DateTime
            property :updated_at, :type => DateTime
            property :version
            index :created_at, :type => DateTime
            index :updated_at, :type => DateTime
            index :version

            alias_method_chain :set_property, :hooks
          end
        end

        def set_property_with_hooks(name, value)
          ::Neo4j::Transaction.run do
            set_property_without_hooks(name.to_s, value)
            update_date_and_version
          end
        end

        private

        def update_date_and_version
          set_property_without_hooks('created_at', DateTime.now) if created_at.blank?
          set_property_without_hooks('updated_at', DateTime.now)

          current_version = self.version || 0
          set_property_without_hooks('version', current_version += 1)
        end
      end



      module NodeValidations
        def self.included(base)
          base.class_eval do
            include ActiveRecord::Validations
            attr_accessor :errors

            # needed if not valid after validation
            def self.self_and_descendents_from_active_record
              []
            end

            def self.human_name
              self.name.humanize
            end

            def self.human_attribute_name(attribute_name)
              attribute_name.to_s
            end
          end
        end

        # stubbing some needed methods from ActiveRecord
        def save; end
        def save!; end
        def update_attribute; end
      end

    end
  end
end