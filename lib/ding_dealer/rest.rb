module DingDealer
  module Rest

    def self.included(base)
      base.extend ClassMethods
    end

    PublicActionMethods = [ :new, :create, :index, :show, :edit, :update, :destroy ]

    module ClassMethods
      def uses_rest(options = {}, &block)
        Dsl.new(self).evaluate_dsl(&block).set_defaults
        include FilterHooks
        extend SingletonMethods
        include PublicActions
        include ObjectInitalizations
        include ActionOperations
        include ActionRenderer
      end

      alias :use_rest :uses_rest
    end



    class Dsl
      def initialize(controller_klass)
        @controller_klass = controller_klass
        setup_dsl
      end

      def setup_dsl
        @controller_klass.class_eval do
          class_inheritable_accessor :rest_env
          attr_accessor :rest_run
          before_filter { |controller| DingDealer::Rest::RestRun.init_rest_run(controller) }
          hide_action :rest_env, :rest_run, :rest_env=, :rest_run=
        end

        @controller_klass.rest_env = dingsl_accessor do
          model     dingsl_accessor(:klass, :object_name, :collection_name, :object_symbol,
                                    :collection_symbol, :object_instance_symbol, :collection_instance_symbol)
          paths     dingsl_accessor(:object, :collection, :new, :edit)
          dsl
        end

        @controller_klass.rest_env.dsl = self
      end

      def evaluate_dsl(&block)
        @controller_klass.rest_env.instance_eval(&block) if block_given?
        self
      end

      def set_defaults
        controller_klass = @controller_klass
        rest_env = @controller_klass.rest_env
        rec_ident = ActionController::RecordIdentifier

        evaluate_dsl do
          model do
            klass controller_klass.name.gsub(/Controller$/, "").singularize.constantize unless klass
          end

          model do
            object_name                 rec_ident.singular_class_name(klass)  unless object_name
            collection_name             rec_ident.plural_class_name(klass)    unless collection_name
            object_symbol               object_name.to_sym                    unless object_symbol
            collection_symbol           collection_name.to_sym                unless collection_symbol
            object_instance_symbol      "@#{object_name}".to_sym              unless object_instance_symbol
            collection_instance_symbol  "@#{collection_name}".to_sym          unless collection_instance_symbol
          end

          paths do
            object      rec_ident.dom_class(rest_env.model.klass)             unless object
            collection  rec_ident.dom_class(rest_env.model.klass).pluralize   unless collection
            edit        rec_ident.dom_class(rest_env.model.klass, :edit)      unless edit
            new         rec_ident.dom_class(rest_env.model.klass, :new)       unless new
          end
        end

        self
      end
    end



    module FilterHooks
      def self.included(base)
        base.class_eval do
          before_filter :init_new,      :only => :new
          before_filter :init_create,   :only => :create
          before_filter :init_index,    :only => :index
          before_filter :init_show,     :only => :show
          before_filter :init_edit,     :only => :edit
          before_filter :init_update,   :only => :update
          before_filter :init_destroy,  :only => :destroy
        end
      end
    end


    module SingletonMethods; end



    class RestRun

      # attr_accessor :response_status

      def self.init_rest_run(controller_instance)
        controller_instance.rest_run = RestRun.new(controller_instance)
      end

      def initialize(controller_instance)
        @controller_instance = controller_instance
        @rest_env = @controller_instance.rest_env
      end

      def current_object=(value)
        @controller_instance.instance_variable_set(@rest_env.model.object_instance_symbol, value)
      end

      def current_object
        @controller_instance.instance_variable_get(@rest_env.model.object_instance_symbol)
      end

      def current_collection=(values)
        @controller_instance.instance_variable_set(@rest_env.model.collection_instance_symbol, values)
      end

      def current_collection
        @controller_instance.instance_variable_get(@rest_env.model.collection_instance_symbol)
      end

      def collection_path
        @controller_instance.send("#{@rest_env.paths.collection}_path")
      end

      def object_path(prefix = nil)
        prefix = prefix ? "#{prefix}_" : nil
        @controller_instance.send("#{prefix}#{@rest_env.paths.object}_path", current_object)
      end

      def init_current_object_by_params
        self.current_object = @rest_env.model.klass.load(@controller_instance.params[:id])
      end

      def current_params_hash
        @controller_instance.params[@rest_env.model.object_symbol]
      end

      def my_created_collection
        my.send("created_#{@rest_env.model.collection_name}")
      end
    end

    module PublicActions
      public
      PublicActionMethods.each do | action |
        class_eval <<-"RUBY"
          def #{action}
            operate_#{action}
            render_#{action}
          end
        RUBY
      end
    end



    module ObjectInitalizations
      private

      def init_new
        rest_run.current_object = rest_env.model.klass.value_object.new
      end

      def init_create; end

      def init_index
        rest_run.current_collection = rest_run.my_created_collection
      end

      def init_show
        rest_run.init_current_object_by_params
      end

      def init_edit
        rest_run.init_current_object_by_params
      end

      def init_update
        rest_run.init_current_object_by_params
      end

      def init_destroy
        rest_run.init_current_object_by_params
      end
    end



    module ActionOperations
      private

      def operate_new; end

      def operate_create
        rest_run.current_object = rest_env.model.klass.new_with_validations(rest_run.current_params_hash)
        if rest_run.current_object.valid?
          rest_run.my_created_collection << rest_run.current_object
        end
      end

      def operate_index; end
      def operate_show; end
      def operate_edit; end

      def operate_update
        rest_run.current_object =
          rest_env.model.klass.update_with_validations(rest_run.current_object, rest_run.current_params_hash)
        if rest_run.current_object.valid?
          rest_run.my_created_collection << rest_run.current_object
        end
      end

      def operate_destroy
        rest_run.current_object.delete
      end
    end



    module ActionRenderer
      private

      def render_index
        respond_to do |format|
          format.html
        end
      end

      def render_new
        respond_to do |format|
          format.html
        end
      end

      def render_create
        if rest_run.current_object.valid?
          render_create_with_success
        else
          render_create_without_success
        end
      end

      def render_create_with_success
        respond_to do |format|
          flash[:notice] = 'successfully created.'
          format.html { redirect_to rest_run.object_path(:edit) }
        end
      end

      def render_create_without_success
        flash[:error] = 'not saved !'
        render :action => :new, :status => :unprocessable_entity
      end

      def render_show
        respond_to do |format|
          format.html
        end
      end

      def render_edit; end

      def render_update
        if rest_run.current_object.valid?
          render_update_with_success
        else
          render_update_without_success
        end
      end

      def render_update_with_success
        respond_to do |format|
          flash[:notice] = 'successfully updated.'
          format.html { redirect_to rest_run.object_path }
        end
      end

      def render_update_without_success
        flash[:error] = 'not saved !'
        render :action => :edit, :status => :unprocessable_entity
      end

      def render_destroy
        respond_to do |format|
          format.html { redirect_to rest_run.collection_path }
        end
      end
    end

  end
end