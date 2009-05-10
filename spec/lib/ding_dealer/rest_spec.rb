require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe DingDealer::Rest, ' with default settings' do
  before(:all) do
    start_neo4j
    undefine_class :MonkeysController, :Monkey
    class Monkey; end
    class MonkeysController < ApplicationController
      uses_rest
    end
  end

  after(:all) { stop_neo4j }

  describe "the rest_env environment" do
    before :all do
      @rest_env = MonkeysController.rest_env
    end

    it "should have an rest_env", 'with the rest environment as DingDealer::Struct' do
      @rest_env.should be_kind_of(DingDealer::Struct)
    end

    it "should have a rest_env.model based on default model naming conventions " do
      @rest_env.model.klass.should  ==                        Monkey
      @rest_env.model.object_name.should ==                   'monkey'
      @rest_env.model.collection_name.should ==               'monkeys'
      @rest_env.model.object_symbol.should ==                 :monkey
      @rest_env.model.collection_symbol.should  ==            :monkeys
      @rest_env.model.object_instance_symbol.should ==        :@monkey
      @rest_env.model.collection_instance_symbol.should ==    :@monkeys
    end

    it "should have a rest_env.paths based on default naming conventions " do
      @rest_env.paths.object.should      == 'monkey'
      @rest_env.paths.collection.should  == 'monkeys'
      @rest_env.paths.new.should         == 'new_monkey'
      @rest_env.paths.edit.should        == 'edit_monkey'
    end
  end

  describe "the rest_run environment" do

  end
end



describe DingDealer::Rest, ' with a customized namespaced model' do
  before(:all) do
    start_neo4j
    undefine_class :ElephantsController
    module Animal
      class Tiger; end
    end
    class ElephantsController < ApplicationController
      uses_rest do
        model.klass Animal::Tiger
      end
    end

    @rest_env = ElephantsController.rest_env
  end

  after(:all) { stop_neo4j }

  it "should have a rest_env.model based on customized model naming conventions " do
    @rest_env.model.klass.should  ==                        Animal::Tiger
    @rest_env.model.object_name.should ==                   'animal_tiger'
    @rest_env.model.collection_name.should ==               'animal_tigers'
    @rest_env.model.object_symbol.should ==                 :animal_tiger
    @rest_env.model.collection_symbol.should ==             :animal_tigers
    @rest_env.model.object_instance_symbol.should ==        :@animal_tiger
    @rest_env.model.collection_instance_symbol.should ==    :@animal_tigers
  end

  it "should have a rest_env.paths based on customized naming conventions " do
    @rest_env.paths.object.should      == 'animal_tiger'
    @rest_env.paths.collection.should  == 'animal_tigers'
    @rest_env.paths.new.should         == 'new_animal_tiger'
    @rest_env.paths.edit.should        == 'edit_animal_tiger'
  end
end



describe DingDealer::Rest, ' with all settings customized' do
  before(:all) do
    start_neo4j
    undefine_class :ElephantsController, :Cat
    class Cat; end
    class ElephantsController < ApplicationController
      uses_rest do
        model do
          klass Cat
          object_name 'object_name'
          collection_name 'collection_name'
          object_symbol :object_symbol
          collection_symbol :collection_symbol
          object_instance_symbol :object_instance_symbol
          collection_instance_symbol :collection_instance_symbol
        end
        paths do
          object 'object'
          collection 'collection'
          new 'new'
          edit 'edit'
        end
      end
    end

    @rest_env = ElephantsController.rest_env
  end

  after(:all) { stop_neo4j }

  it "should have a rest_env.model based the configured settings" do
    @rest_env.model.klass.should  ==                        Cat
    @rest_env.model.object_name.should ==                   'object_name'
    @rest_env.model.collection_name.should ==               'collection_name'
    @rest_env.model.object_symbol.should ==                 :object_symbol
    @rest_env.model.collection_symbol.should ==             :collection_symbol
    @rest_env.model.object_instance_symbol.should ==        :object_instance_symbol
    @rest_env.model.collection_instance_symbol.should ==    :collection_instance_symbol
  end

  it "should have a rest_env.paths based the configured settings" do
    @rest_env.paths.object.should      == 'object'
    @rest_env.paths.collection.should  == 'collection'
    @rest_env.paths.new.should         == 'new'
    @rest_env.paths.edit.should        == 'edit'
  end
end




undefine_class :Bean, :BeansController

class Bean
  is_a_neo_node do
    db.validations true
  end
  property :name
  validates_length_of :name, :minimum => 3
end

# routes are have been moved to spec_helper.rb

class BeansController < ActionController::Base
  use_rest
  def full_access_for_test; end
end



describe "a controller instance", ' with default convention based settings', :type => :controller do
  controller_name 'beans'

  before(:all) { start_neo4j }
  before(:each) { controller.stub!(:default_template).and_return('some_non_existing_template_path') }
  after(:all) { stop_neo4j }


  it "should have an rest_run and other rest_run.methods" do
    get :full_access_for_test
    controller.should respond_to(:rest_run)
  end

  it "should have only the standard rest methods public accessable" do
    public_actions = ["index", "update", "create", "new", "show", "destroy", "edit"]
    some_extra_methods = ["full_access_for_test"]
    controller.class.action_methods.should == (public_actions + some_extra_methods).to_set
  end


  describe "some usage scenarios" do
    context 'with valid values' do
      before(:each) do
        Me.now = mock(User, :created_beans => [])
        @bean = Bean.new
      end

      it "should #new" do
        get :new
        response.should be_success

        assigns(:bean).should be_a_kind_of Neo4j::BeanValueObject
        controller.rest_run.current_object.should be assigns(:bean)
      end

      it "should #create" do
        number_of_all_nodes = Bean.all_nodes.to_a.size

        post :create, :bean => { :name => 'salt' }
        bean = assigns(:bean)

        response.should redirect_to edit_bean_path(bean)
        flash[:notice].should  == 'successfully created.'

        bean.name.should == 'salt'
        bean.should be_a_kind_of Bean
        controller.rest_run.current_object.should be bean

        bean.should be_valid
        bean.errors.should be_empty
        Bean.all_nodes.to_a.size.should == number_of_all_nodes + 1
      end

      it "should #index" do
        get :index
        beans = assigns(:beans)

        response.should be_success

        beans.should == my.created_beans
        controller.rest_run.current_collection.should be beans
      end

      it "should #show" do
        get :show, :id => @bean.id
        bean = assigns(:bean)

        response.should be_success

        bean.should == @bean
        controller.rest_run.current_object.should be bean
      end

      it "should #edit" do
        get :edit, :id => @bean.id
        bean = assigns(:bean)

        response.should be_success

        bean.should == @bean
        controller.rest_run.current_object.should be bean
      end

      it "should #update" do
        put :update, :id => @bean.id, :bean => { :name => 'suppe' }
        bean = assigns(:bean)

        response.should redirect_to bean_path(@bean)

        flash[:notice].should == 'successfully updated.'
        bean.should == @bean
        controller.rest_run.current_object.should be bean

        bean.should be_valid
        bean.errors.should be_empty
      end

      it "should #destroy" do
        delete :destroy, :id => @bean.id
        bean = assigns(:bean)

        response.should redirect_to beans_path

        bean.should == @bean
        controller.rest_run.current_object.should be bean
      end
    end



    context 'with invalid values' do
      before(:each) do
        Me.now = mock(User, :created_beans => [])
        @number_of_all_beans = Bean.all_nodes.to_a.size
      end

      it "should #create with errors", ' without changing the node' do
        post :create, :bean => { :name => 'su' }
        bean = assigns(:bean)

        response.status.should == "422 Unprocessable Entity"
        flash[:error].should == 'not saved !'

        bean.should be_a_kind_of Neo4j::BeanValueObject
        bean.name.should == 'su'
        bean.should_not be_valid
        bean.should have(1).error_on(:name)

        Bean.all_nodes.to_a.size.should == @number_of_all_beans
      end

      it "should #update with errors", ' without changing the node' do
        original_bean = Bean.new(:name => 'tiger')

        put :update, :id => original_bean.id, :bean => { :name => 'ts' }
        bean = assigns(:bean)

        response.status.should == "422 Unprocessable Entity"
        flash[:error].should == 'not saved !'

        bean.should be_a_kind_of Neo4j::BeanValueObject
        bean.name.should == 'ts'
        bean.should_not be_valid
        bean.should have(1).error_on(:name)
        original_bean.name.should == 'tiger'

        # Bean.all_nodes.to_a.size.should == @number_of_all_beans
      end
    end
  end

end

