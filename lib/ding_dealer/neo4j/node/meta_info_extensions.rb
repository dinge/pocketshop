module DingDealer
  module Neo4j
    module Node

      module MetaInfoExtensions
        def self.included(base)
          base.class_eval do
            property  :created_at, :type => DateTime
            property  :updated_at, :type => DateTime
            property  :version
            property  :uuid

            index     :created_at, :type => DateTime
            index     :updated_at, :type => DateTime
            index     :version
            index     :uuid

            ::Neo4j.event_handler.add( EventHandlerHooks.new(base) )
          end
        end

        class EventHandlerHooks
          MetaMethods = %w(created_at updated_at version uuid)

          def initialize(node_klass)
            @node_klass = node_klass
          end

          def on_node_created(node)
            if node.is_a?(@node_klass)
              node[:created_at] = DateTime.now.utc
              node[:updated_at] = DateTime.now.utc
              node[:version]    = 1
              node[:uuid]       = java.util.UUID.randomUUID.to_s
            end
          end

          def on_property_changed(node, key, old_value, new_value)
            if node.is_a?(@node_klass) && ! MetaMethods.include?(key) # don't update when a meta attribute itsself changed
              node[:updated_at] = DateTime.now.utc
              node[:version]    = node[:version] += 1
            end
          end

        end

      end

    end
  end
end