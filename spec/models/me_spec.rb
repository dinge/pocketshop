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


  # it "should set Me.now to nil calling reset" do
  #   Me.now = @user_stub
  #   Me.now.should be @user_stub
  #   Me.reset
  #   Me.now.should be nil
  # end
  # 
  # it "should return true if Me.now is someone calling someone?" do
  #   Me.now = @user_stub
  #   Me.someone?.should be true
  #   Me.none?.should be false
  # end
  # 
  # it "should return false if Me.now is no one calling someone?" do
  #   Me.someone?.should be false
  #   Me.none?.should be true
  # end
  # 
  # it "should save some information" do
  #   controller_request = mock "ActionController::Request"
  #   controller_request.stub!(:query_parameters).and_return('/my/last/request')
  # 
  #   Me.now = Local::User.new
  #   Me.update_last_action(controller_request)
  #   Me.now.last_action.should == '/my/last/request'
  #   # Me.now.last_action_at.to_s.should == DateTime.now.to_s
  # end

end


describe "my" do
  before(:all) do
    start_neo4j
    Me.now = Local::User.new
  
    @my_tags = (1..3).map do |i|
      Tag.new(:name => "tag_#{i}")
    end

    @my_tags.each do |tag|
      Me.now.created_tags << tag
    end
  end

  after(:all) do
    stop_neo4j
  end

  it "my should by Me.now" do
    my.should be Me.now
  end

  it "should return my number of things calling my.count_my" do
    my.count_my(:created_tags).should be 3
  end

  it "should return an inspect dump of my tags calling my.dump_my" do
    my.dump_my(:created_tags).should be_kind_of(String)
    # my.dump_my(:created_tags).should == Me.now.created_tags.to_a.inspect
  end

  it "should return my node's names calling my.dump_my_names " do
    @my_tags.each do |tag|
      my.dump_my_names(:created_tags).should include(tag.name)
    end
  end
  
  it "should return my node's classes calling my.dump_my_classes " do
    @my_tags.each do |tag|
      my.dump_my_classes(:created_tags).should include(tag.class)
    end
  end

end