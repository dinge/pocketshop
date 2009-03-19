module DingDealer
  module Rest

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def use_acl
        # cattr_accessor :acl
        # self.acl = Struct.new(:visible).new('no')
        # yield if block_given?
        # extend  SingletonMethods
        # include InstanceMethods
      end

      # def acl
      #   extend  SingletonMethods
      #   class_scoping_reader :create, :none
      #   self
      # end


    end


    module SingletonMethods

      # def class_scoping_reader(accessor_name, start_value = nil)
      #   write_inheritable_attribute accessor_name, start_value
      #   
      #   class_eval <<-"end_eval", __FILE__, __LINE__
      #     def self.#{accessor_name}(&block)
      #       read_inheritable_attribute(:#{accessor_name}).instance_eval(&block) if block_given?
      #       read_inheritable_attribute(:#{accessor_name})
      #     end
      #   end_eval
      # end
      # 
    end


    module InstanceMethods

    end


  end
end