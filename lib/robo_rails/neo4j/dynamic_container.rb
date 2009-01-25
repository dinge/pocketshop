module RoboRails
  module Neo4j
    module DynamicContainer

      def self.included(base)
        base.extend(ClassMethods)
      end

      class BlankValueError < StandardError ; end

      module ClassMethods
        def is_a_dynamic_container
          include InstanceMethods
        end
      end


      module InstanceMethods

        def initialize(attributes = {}, &block)
          init_by_hash(attributes)
          instance_eval(&block) if block_given?
        end

        def init_by_hash(attributes)
          attributes.each do |key, value|
            send("#{key.to_s}=", value)
          end
        end

        ReaderMethod = /([a-zA-Z0-9_-]+)/
        WriterMethod = /([a-zA-Z0-9_-]+)=/
        QueryMethod = /([a-zA-Z0-9_-]+)\?/
        BangMethod = /([a-zA-Z0-9_-]+)!/

        # catch calls to thing.some_attribute, thing.some_attribute = some_value and thing.some_attribute?
        # and build them as runtime method
        def method_missing(method, *args)

          instance_variables = symbolized_instance_variables

          case method.to_s

            when WriterMethod
              build_attribute_accessor_methods($1)
              send(method, *args)

            when BangMethod
              if instance_variables.include?($1.to_sym)
                build_bang_attribute_reader_method($1)
                send(method)
              else
                raise NoMethodError
              end

            when QueryMethod
              if instance_variables.include?($1.to_sym)
                build_attribute_query_method($1)
                send(method)
              else
                false
              end

            when ReaderMethod
              if instance_variables.include?(method)
                build_attribute_accessor_methods(method)
                send(method)
              end

            else
              raise NoMethodError

          end
        end


        def symbolized_instance_variables
          instance_variables.map do |iv|
            iv.gsub(/@/,'').to_sym
          end
        end

        def attributes
          to_hash
        end

        def to_hash
          attributes_hash = HashWithIndifferentAccess.new
          symbolized_instance_variables.each do |field_name|
            attributes_hash[field_name.to_s] = instance_variable_get("@#{field_name}")
          end
          attributes_hash
        end

        def to_a
          to_hash.to_a
        end

        def marshal_dump
          YAML.dump(self)
        end
        
        def marshal_load(marshaled)
          init_by_hash(YAML.load(marshaled).to_hash)
        end

        protected

        # dynamically build reader thing.some_attribute
        def build_attribute_accessor_methods(method)
          class_eval <<-RUBY
            attr_accessor :#{method}
          RUBY
        end


        # dynamically build query thing.some_attribute?
        def build_attribute_query_method(method)
          instance_eval <<-RUBY
            def #{method}?
              true
            end
          RUBY
        end

        # returns value or raises BlankValueError if the value is blank?
        def build_bang_attribute_reader_method(method)
          instance_eval <<-RUBY
            def #{method}!
              if @#{method}.blank?
                raise BlankValueError
              else
                @#{method}
              end
            end
          RUBY
        end

      end

    end
  end
end
