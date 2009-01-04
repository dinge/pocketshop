module RoboRails
  module XGen
    module Mongo
      module WorksWithDynamicAttributes

        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def works_with_dynamic_attributes
            include InstanceMethods
          end
        end


        module InstanceMethods

          # overwriting method from super
          def to_mongo_value
            h = {}
            # TODO: check if it is good to delete nil values
            self.symbolized_instance_variables.each do |iv|
              unless (value = instance_variable_get("@#{iv}")).nil?
                h[iv] = value.to_mongo_value
              end
            end
            h
          end

          def symbolized_instance_variables
            instance_variables.map do |iv|
              iv.gsub(/@/,'').to_sym
            end
          end

          # catch calls to thing.some_attribute, thing.some_attribute = some_value and thing.some_attribute?
          # and build them as runtime method
          def method_missing(method, *args)
            if symbolized_instance_variables.include?(method)
              build_attribute_reader_method(method)
              send(method)

            elsif method.to_s =~ /([a-zA-Z0-9_]+)=/ #&& !symbolized_instance_variables.include?($1.to_sym)
              build_attribute_writer_method($1)
              send(method, *args)

            # TODO: check if this should an exception for non existing attributes
            # false is returned at this moment
            elsif method.to_s =~ /([a-zA-Z0-9_]+)?/
              if symbolized_instance_variables.include?($1.to_sym)
                build_attribute_query_method($1)
                send(method)
              else
                false
              end

            else
              super
            end
          end

          def attributes
            attributes_hash = {}
            symbolized_instance_variables.each do |field_name|
              attributes_hash[field_name.to_s] = instance_variable_get("@#{field_name}")
            end
            attributes_hash
          end


          protected

          # dynamically build reader thing.some_attribute
          def build_attribute_reader_method(method)
            instance_eval <<-RUBY
              def #{method}
                @#{method}
              end
            RUBY
          end

          # dynamically build writer thing.some_attribute = some_value
          def build_attribute_writer_method(method)
            instance_eval <<-RUBY
              def #{method}=(param)
                @#{method} = param
              end
            RUBY
          end

          # dynamically build query thing.some_attribute?
          def build_attribute_query_method(method)
            instance_eval <<-RUBY
              def #{method}?
                !@#{method}.blank?
              end
            RUBY
          end

        end

      end
    end
  end
end
