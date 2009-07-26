module DingDealer
  class Struct

    def initialize(*attributes, &block)
      @_attribute_names, @_uninitialized = [], true
      init_by_arguments(attributes, &block)
      remove_instance_variable(:@_uninitialized)
    end

    def set(&block)
      instance_eval(&block)
      self
    end

    def to_hash
      attributes_hash = HashWithIndifferentAccess.new
      @_attribute_names.each do |attribute_name|
        value = instance_variable_get("@#{attribute_name}")
        attributes_hash[attribute_name.to_s] = value.is_a?(DingDealer::Struct) ? value.to_hash : value
      end
      attributes_hash
    end

    def [](attribute)
      send(attribute)
    end

    def to_a
      to_hash.to_a
    end

    def instance_variables
    end

    protected

    def init_by_arguments(attributes, &block)
      attribute_names = attributes.first.is_a?(Hash) ? from_hash(attributes.first) : from_array(*attributes)
      struct_accessors(attribute_names)
      from_block(&block) if block_given?
    end

    def from_array(*attributes)
      attributes.flatten.map(&:to_sym)
    end

    def from_hash(attributes_with_default_values)
      attributes_with_default_values.each do |attribute, default_value|
        instance_variable_set(:"@#{attribute}", default_value)
      end
      from_array(attributes_with_default_values.keys)
    end

    def from_block(&block)
      instance_eval(&block)
    end

    def struct_accessors(attribute_names)
      attribute_names.each do |attribute|
        struct_accessor(attribute)
      end
    end


    ReaderMethod = /([a-zA-Z0-9_-]+)/
    WriterMethod = /([a-zA-Z0-9_-]+)=/
    PredicateMethod = /([a-zA-Z0-9_-]+)\?/

    def method_missing(method, *args)
      case method.to_s
      when PredicateMethod then false
      when WriterMethod, ReaderMethod
        build_methods_on_method_missing(method, args, $1)
      else
        raise NoMethodError.new("#{method} not found in #{self.inspect}")
      end
    end

    def build_methods_on_method_missing(method, args, attribute)
      if @_uninitialized
        struct_accessor(attribute)
        send(method, *args)
      else
        raise NoMethodError.new("#{method} not found in #{self.inspect}")
      end
    end

    def struct_accessor(attribute)
      @_attribute_names << attribute.to_sym
      struct_writer(attribute)
      struct_reader(attribute)
      struct_predicate(attribute)
    end

    # dynamically build reader thing.some_attribute
    def struct_writer(method)
      class_eval <<-RUBY
        attr_writer :#{method}
      RUBY
    end

    def struct_reader(method)
      instance_eval <<-RUBY
        def #{method}(value = (empty_argument = true; nil), &block)
          if !empty_argument
            @#{method} = value
            self
          elsif block_given?
            @#{method}.instance_eval(&block)
            self
          else
            @#{method}
          end
        end
      RUBY
    end

    # dynamically build predicate thing.some_attribute?
    def struct_predicate(method)
      instance_eval <<-RUBY
        def #{method}?
          true
        end
      RUBY
    end

  end
end