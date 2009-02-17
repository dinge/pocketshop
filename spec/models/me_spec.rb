require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Me do

  before(:all) do
    start_neo4j
  end

  before(:each) do
    Me.now = nil
    @user_stub = mock_model(Local::User, :name => 'haina')
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
    # Me.now = Local::User.new
    #
    # Me.update_last_action(controller_request)
    # Me.now.last_action.should == '/my/last/request'
    # Me.now.last_action_at.to_s.should == DateTime.now.to_s
  end

end


describe "global my" do
  before(:all) do
    start_neo4j

    Me.now = Local::User.new
    undefine_class :Ding

    class Ding
      is_a_neo_node
      property :name
    end

    class Local::User
      has_n(:created_dings).to(Tag).relation(Acl::Created)
    end

    @my_dings = (1..3).map do |i|
      Ding.new(:name => "ding_#{i}")
    end

    @my_dings.each do |ding|
      Me.now.created_dings << ding
    end
  end

  after(:all) do
    stop_neo4j
  end


  it "should be globaly available" do
    Object.should respond_to(:my)
  end

  it "should by Me.now" do
    my.should be Me.now
  end

  context "for debugging and knowledge generation" do
    it "calling count_my(:created_dings) should return the number of dings" do
      count_my(:created_dings).should be 3
    end

    it "calling my.dump_my(:created_dings) should return an inspect dump of my dings" do
      dump_my(:created_dings).should be_a_kind_of(String)
    end

    it "calling my.dump_names_of_my(:created_dings) should return my dings' names" do
      @my_dings.each do |ding|
        dump_names_of_my(:created_dings).should include(ding.name)
        ding.should be_a_instance_of(Ding)
      end
    end

    it "calling my.dump_classes_of_my(:created_dings) should return my dings' classes" do
      @my_dings.each do |ding|
        dump_classes_of_my(:created_dings).should include(ding.class)
        ding.should be_a_instance_of(Ding)
      end
    end
  end

end