require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Thing do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    # Thing.create!(@valid_attributes)
    thing = Thing.new
    thing.should_not be_instance_of(Thing)
    
  end
end
