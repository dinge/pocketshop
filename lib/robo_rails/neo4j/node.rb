module RoboRails
  module Neo4j

    class NotFoundException < StandardError; end

    module Node

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods

        def is_a_neo_node(options = {})
          include_neo_mixins(options)
        end

        private

        def include_neo_mixins(options)
          include ::Neo4j::NodeMixin
          include ::Neo4j::DynamicAccessorMixin if options[:dynamic_properties]

          class_eval do
            extend SingletonMethods
            extend SingletonMethodsExtensions
          end

          include InstanceMethods
          include InstanceMethodExtensions

          if options[:with_meta_info]
            class_eval do
              property :created_at, :type => DateTime
              property :updated_at, :type => DateTime
              property :version

              index :created_at, :type => DateTime
              index :updated_at, :type => DateTime
              index :version
            end
          end

        end

      end


      module SingletonMethods

        def l(neo_node_id)
          node = ::Neo4j.load(neo_node_id)
          raise RoboRails::Neo4j::NotFoundException unless node.is_a?(self)
          node
        end

        # overwriting something from parent class, seems to work ..
        alias :load :l

        def property_names
          properties_info.keys
        end

        # TODO: does'n scale, find a better way, all objects are loaded, but works for my test as interface
        def first
          all.nodes.to_a.first
        end

        # TODO: does'n scale, find a better way, all objects are loaded, but works for my test as interface
        def last
          all.nodes.to_a.last
        end


      end


      module SingletonMethodsExtensions

      end



      module InstanceMethods

        def id
          neo_node_id
        end

        def to_param
          "#{id}-#{name}"
        end


        private

        def update_date_and_version
          if self.class.property?(:created_at) && created_at.blank?
            set_property_without_hooks('created_at', DateTime.now)
          end

          if self.class.property?(:updated_at)
            set_property_without_hooks('updated_at', DateTime.now)
          end

          if self.class.property?(:version)
            version = self.version || 0
            set_property_without_hooks('version', version += 1)
          end
        end

      end



      module InstanceMethodExtensions

        def self.included(base)
          base.class_eval do
            extend ::Neo4j::TransactionalMixin
            alias_method_chain :set_property, :hooks
            transactional :set_property_with_hooks, :set_property_without_hooks
          end
        end

        def set_property_with_hooks(name, value)
          set_property_without_hooks(name.to_s, value)
          update_date_and_version
        end


      end


    end
  end
end
