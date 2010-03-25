module DingDealer
  module Neo4j
    module Node

      module Validations
        def self.included(base)
          base.class_eval do
            include ActiveRecord::Validations
            attr_writer :errors
            # needed if not valid after validation
            def self.self_and_descendents_from_active_record; [] end
            def self.self_and_descendants_from_active_record; [] end # since rails 2.3.2

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