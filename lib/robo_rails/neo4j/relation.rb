module RoboRails
  module Neo4j

    # class NotFoundException < StandardError; end

    module Relation

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods

        def is_a_neo_relation(options = {})
          include_neo_relation_mixins(options)
        end

        private

        def include_neo_relation_mixins(options)
          include ::Neo4j::RelationMixin
          attr_reader :internal_r

          class_eval do
            extend SingletonMethods
            extend SingletonMethodsExtensions
          end

          if options[:with_meta_info]
            class_eval do
              property :created_at
              property :updated_at
              property :version
            end
          end

          include InstanceMethods
          include InstanceMethodExtensions

        end

      end


      module SingletonMethods

      end


      module SingletonMethodsExtensions

      end


      module InstanceMethods

        def id
          neo_relation_id
        end


        private

        def update_date_and_version
          if respond_to?(:created_at) && created_at.blank?
            set_property_without_hooks('created_at', DateTime.now.to_s)
          end

          if respond_to?(:updated_at)
            set_property_without_hooks('updated_at', DateTime.now.to_s)
          end

          if respond_to?(:version)
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
            alias_method_chain :created_at, :typecast
            alias_method_chain :updated_at, :typecast
            transactional :set_property_with_hooks, :set_property_without_hooks
          end
        end

        def set_property_with_hooks(name, value)
          set_property_without_hooks(name.to_s, value)
          update_date_and_version
        end

        def created_at_with_typecast
          DateTime.parse(get_property('created_at'))
        end

        def updated_at_with_typecast
          DateTime.parse(get_property('updated_at'))
        end

      end

    end
  end
end
