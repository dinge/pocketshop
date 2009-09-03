module DingDealer
  module Neo4j
    module Node

      module MetaInfoExtensions
        def self.included(base)
          base.class_eval do
            property  :created_at, :type => DateTime
            property  :updated_at, :type => DateTime
            property  :version

            index     :created_at, :type => DateTime
            index     :updated_at, :type => DateTime
            index     :version

            ::Neo4j.event_handler.add(EventHandlerHooks)
          end
        end

        class EventHandlerHooks
          MetaMethods = %w(created_at updated_at version)

          def self.on_node_created(node)
            if has_meta_info_methods?(node)
              node.set_property('created_at', DateTime.now)
              node.set_property('version', 1)
            end
          end

          def self.on_property_changed(node, key, old_value, new_value)
            if has_meta_info_methods?(node) && ! MetaMethods.include?(key)
              node.set_property('updated_at', DateTime.now)
              node.set_property('version', (node.version += 1) )
            end
          end

          def self.has_meta_info_methods?(node)
            node.class.properties?(MetaMethods)
          end
        end
      end

    end
  end
end