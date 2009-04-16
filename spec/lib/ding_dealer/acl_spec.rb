require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe DingDealer::Acl do

  before(:all) do
    start_neo4j
    undefine_class :MonkeysController, :Monkey, :ElephantsController

    class Monkey; end

    class MonkeysController < ApplicationController
      uses_rest
      uses_acl
    end

    class ElephantsController < ApplicationController
      uses_acl do
        strategy :dummy_permissions
      end
    end
  end

  after(:all) { stop_neo4j }

  it "should have an acl_env", 'with the acl environment as DingDealer::Struct' do
    MonkeysController.acl_env.should be_kind_of(DingDealer::Struct)
  end

  it "should have :standard_permissions as default strategy" do
    MonkeysController.acl_env.strategy.should == :standard_permissions
  end

  it "should have a configurable strategy" do
    ElephantsController.acl_env.strategy.should == :dummy_permissions
  end
end



undefine_class :Dummy, :DummiesController

class Dummy
  is_a_neo_node do
    db.dynamic_properties true
  end

  property :name

  def self.creatable_for?(user)
    user.name == 'let_me_in'
  end

  def visible_for?(user)
    user.name == 'let_me_in'
  end

  def changeable_for?(user)
    user.name == 'let_me_in'
  end

  def destroyable_for?(user)
    user.name == 'let_me_in'
  end
end

# routes are have been moved to spec_helper.rb

class DummiesController < ActionController::Base
  use_rest
  uses_acl
  def full_access_for_test; end
end


describe "a controller instance", ' with standard_permissions', :type => :controller do
  controller_name 'dummies'

  before(:all) { start_neo4j }
  after(:all) { stop_neo4j }

  it "should have an acl_run and other acl_run.methods" do
    get :full_access_for_test
    controller.should respond_to(:acl_run)
    controller.acl_run.should respond_to(:creatable?)
    controller.acl_run.should respond_to(:visible?)
    controller.acl_run.should respond_to(:changeable?)
    controller.acl_run.should respond_to(:destroyable?)
  end


  describe "some usage scenarios", ' with dummy_permissions' do
    context "granted access", 'with valid user' do
      before(:each) do
        Me.now = mock(User, :name => 'let_me_in', :null_object => true)
        @dummy = Dummy.new
      end

      it "should grant #new" do
        get :new
        response.should be_success
      end

      it "should grant #create" do
        post :create, :dummy => { :name => 'salt' }
        response.should redirect_to edit_dummy_path(assigns(:dummy))
      end

      it "should maybe grant #index" do
        pending
      end

      it "should grant #show" do
        get :show, :id => @dummy.id
        response.should be_success
      end

      it "should grant #edit" do
        get :edit, :id => @dummy.id
        response.should be_success
      end

      it "should grant #update" do
        put :update, :id => @dummy.id, :dummy => { :name => 'suppe' }
        response.should redirect_to dummy_path(@dummy)
      end

      it "should allow #destroy" do
        delete :destroy, :id => @dummy.id
        response.should redirect_to dummies_path
      end
    end

    context "denied access", 'with invalid user' do
      before(:all) do
        Me.now = mock(User, :name => 'dont_let_me_in', :null_object => true)
        @dummy = Dummy.new
      end

      it "should deny #new" do
        get :new
        response.should redirect_to root_url
      end

      it "should deny #create" do
        post :create, :dummy => { :name => 'salt' }
        response.should redirect_to root_url
      end

      it "should maybe deny #index" do
        pending
      end

      it "should deny #show" do
        get :show, :id => @dummy.id
        response.should redirect_to root_url
        flash[:error].should == "access forbidden"
      end

      it "should deny #edit" do
        get :edit, :id => @dummy.id
        response.should redirect_to root_url
        flash[:error].should == "access forbidden"
      end

      it "should deny #update" do
        put :update, :id => @dummy.id, :dummy => { :name => 'suppe' }
        response.should redirect_to root_url
        flash[:error].should == "access forbidden"
      end

      it "should allow #destroy" do
        delete :destroy, :id => @dummy.id
        response.should redirect_to root_url
        flash[:error].should == "access forbidden"
      end

    end

  end

end

