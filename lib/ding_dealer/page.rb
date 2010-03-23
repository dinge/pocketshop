module DingDealer
  module Page

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def uses_page(options = {}, &block)
        Dsl.new(self).evaluate_dsl(&block)
        include ControllerFilters
        extend  SingletonMethods
      end

      alias :use_page :uses_page
    end



    class Dsl
      def initialize(controller_klass)
        @controller_klass = controller_klass
        setup_dsl
      end

      def setup_dsl
        @controller_klass.class_eval do
          class_inheritable_accessor :page_env
          attr_accessor :page_run
          hide_action :page_env, :page_run, :page_env=, :page_run=
        end

        @controller_klass.page_env = dingsl_accessor do
          assets    dingsl_accessor(:additional_javascripts, :additional_stylesheets)
          dsl
        end

        @controller_klass.page_env.dsl = self
      end

      def evaluate_dsl(&block)
        @controller_klass.page_env.instance_eval(&block) if block_given?
        self
      end

    end



    module ControllerFilters
      def self.included(base)
        base.class_eval do
          before_filter { |controller| DingDealer::Page::PageRun.init_page_run(controller) }
        end
      end

  end



    module SingletonMethods; end



    class PageRun
      def self.init_page_run(controller_instance)
        controller_instance.page_run = PageRun.new(controller_instance)
      end

      def initialize(controller_instance)
        @controller_instance = controller_instance
        @page_env = @controller_instance.page_env
      end
    end

  end
end