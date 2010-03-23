module DingDealer
  module Neo4j

    # class NotFoundException < StandardError; end

    module Relation

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def is_a_neo_relation(&block)
          include ::Neo4j::RelationshipMixin
          attr_reader :internal_r
          Dsl.new(self).evaluate_dsl(&block)

          include InstanceMethods
          include MetaInfoExtensions  if neo_relation_env.db.meta_info
        end
      end


      class Dsl
        def initialize(relation_klass)
          @relation_klass = relation_klass
          setup_dsl
        end

        def setup_dsl
          @relation_klass.class_eval do
            class_inheritable_accessor :neo_relation_env
          end

          @relation_klass.neo_relation_env = dingsl_accessor do
            db  dingsl_accessor(:meta_info => false)
            dsl
          end

          @relation_klass.neo_relation_env.dsl = self
        end

        def evaluate_dsl(&block)
          @relation_klass.neo_relation_env.instance_eval(&block) if block_given?
          self
        end
      end



      module InstanceMethods
        def id
          neo_id
        end
      end



      module MetaInfoExtensions
        def self.included(base)
          base.class_eval do
            property :created_at
            property :updated_at
            property :version

            alias_method_chain :created_at, :typecast
            alias_method_chain :updated_at, :typecast

            # alias_method_chain :set_property, :hooks
          end
        end

        def set_property_with_hooks(name, value)
          ::Neo4j::Transaction.run do
            set_property_without_hooks(name.to_s, value)
            update_date_and_version
          end
        end

        def created_at_with_typecast
          return nil if (created_date = self[:created_at].blank?)
          DateTime.parse(created_date)
        end

        def updated_at_with_typecast
          return nil if (updated_date = self[:updated_at].blank?)
          DateTime.parse(updated_date)
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

    end
  end
end