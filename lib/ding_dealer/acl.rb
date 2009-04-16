module DingDealer
  module Acl

    def self.included(base)
      base.extend ClassMethods
    end



    module ClassMethods
      def uses_acl(&block)
        Dsl.new(self).evaluate_dsl(&block).set_defaults
        PermissionStrategies::RunDsl.init(self)
      end

      alias :use_acl :uses_acl
    end



    class Dsl
      def initialize(controller_klass)
        @controller_klass = controller_klass
        setup_dsl
      end

      def setup_dsl
        @controller_klass.class_eval do
          class_inheritable_accessor :acl_env
          attr_accessor :acl_run
          before_filter { |controller| DingDealer::Acl::AclRun.init(controller) }
          hide_action :acl_env, :acl_run, :acl_env=, :acl_run=
        end

        @controller_klass.acl_env = dingsl_accessor do
          strategy :standard_permissions
          dsl
        end

        @controller_klass.acl_env.dsl = self
      end

      def evaluate_dsl(&block)
        @controller_klass.acl_env.instance_eval(&block) if block_given?
        self
      end

      def set_defaults
        controller_klass = @controller_klass
        acl_env = @controller_klass.acl_env
        self
      end
    end



    class AclRun
      def self.init(controller_instance)
        acl_strategy_klass =
        "DingDealer::Acl::PermissionStrategies::#{controller_instance.acl_env.strategy.to_s.camelize}::InstanceMethods".constantize
        controller_instance.acl_run = acl_strategy_klass.new(controller_instance)
      end
    end



    module PermissionStrategies

      class RunDsl
        def self.init(controller_klass)
          acl_strategy_klass =
            "DingDealer::Acl::PermissionStrategies::#{controller_klass.acl_env.strategy.to_s.camelize}::ClassMethods".constantize
          acl_strategy_klass.init(controller_klass)
        end
      end


      module DummyPermissions
        class ClassMethods
          def self.init(controller_klass); end
        end

        class InstanceMethods
          def initialize(controller_instance); end
        end
      end


      module StandardPermissions
        class ClassMethods
          def self.init(controller_klass)
            controller_klass.class_eval do
              before_filter(:only => [:new, :create])   { |controller| controller.acl_run.creatable? }
              before_filter(:only => :show)             { |controller| controller.acl_run.visible? }
              before_filter(:only => [:edit, :update])  { |controller| controller.acl_run.changeable? }
              before_filter(:only => :destroy)          { |controller| controller.acl_run.destroyable? }
            end
          end
        end


        class InstanceMethods
          def initialize(controller_instance)
            @controller_instance = controller_instance
          end

          delegate  :acl_env, :rest_env, :rest_run, :to => :@controller_instance
          delegate  :redirect_to, :root_path, :flash, :to => :@controller_instance

          def creatable?
            unless rest_env.model.klass.creatable_for?(Me.now)
              flash[:error] = "access forbidden"
              redirect_to root_path
            end
          end

          def visible?
            unless rest_run.current_object.visible_for?(Me.now)
              flash[:error] = "access forbidden"
              redirect_to root_path
            end
          end

          def changeable?
            unless rest_run.current_object.changeable_for?(Me.now)
              flash[:error] = "access forbidden"
              redirect_to root_path
            end
          end

          def destroyable?
            unless rest_run.current_object.destroyable_for?(Me.now)
              flash[:error] = "access forbidden"
              redirect_to root_path
            end
          end
        end
      end

    end
  end
end