require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Me do

  before(:all) do
    start_neo4j
  end

  before(:each) do
    Me.now = nil
    @user_stub = mock_model(User, :name => 'haina')
  end

  after(:all) do
    stop_neo4j
  end

  context "someone is Me.now" do
    it "calling someone? should return true" do
      Me.now = @user_stub
      Me.should be_someone
    end

    it "calling none? should return false" do
      Me.now = @user_stub
      Me.should_not be_none
    end

    it "calling reset should set Me.now to nil" do
      Me.now = @user_stub
      Me.now.should be @user_stub
      Me.reset
      Me.now.should be_nil
    end
  end

  context "none is Me.now" do
    it "calling someone? should return false" do
      Me.should_not be_someone
    end

    it "calling none? should return true" do
      Me.should be_none
    end
  end


  it "should save some information" do
    pending "does not work correctly now"
    # controller_request = mock("ActionController::Request")
    # controller_request.stub!(:query_parameters).and_return('/my/last/request')
    #
    # Me.now = User.new
    #
    # Me.update_last_action(controller_request)
    # Me.now.last_action.should == '/my/last/request'
    # Me.now.last_action_at.to_s.should == DateTime.now.to_s
  end

end
