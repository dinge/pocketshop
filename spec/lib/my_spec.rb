require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "global my" do
  before(:all) do
    start_neo4j

    undefine_class :Ding, :SpecialUser

    class Ding
      is_a_neo_node
      property :name
    end

    class SpecialUser
      is_a_neo_node
      has_n(:dings).to(Tag).relation(Acl::Created)
    end

    Me.now = SpecialUser.new

    @my_dings = (1..3).map do |i|
      Ding.new(:name => "ding_#{i}")
    end

    @my_dings.each do |ding|
      Me.now.dings << ding
    end
  end

  after(:all) do
    stop_neo4j
  end


  it "should be globaly available" do
    Object.should respond_to(:my)
  end

  it "should be Me.now" do
    my.should be Me.now
  end

  it "my.dings should return the same as My.now.dings " do
    my.dings.to_a.should == Me.now.dings.to_a
  end

  context "for debugging and knowledge generation" do
    it "calling count_my(:dings) should return the number of dings" do
      count_my(:dings).should be 3
    end

    it "calling dump_my(:dings) should return an inspect dump of my dings" do
      dump_my(:dings).should be_a_kind_of(String)
    end

    it "calling dump_names_of_my(:dings) should return my dings' names" do
      @my_dings.each do |ding|
        dump_names_of_my(:dings).should include(ding.name)
        ding.should be_a_instance_of(Ding)
      end
    end

    it "calling dump_classes_of_my(:dings) should return my dings' classes" do
      @my_dings.each do |ding|
        dump_classes_of_my(:dings).should include(ding.class)
        ding.should be_a_instance_of(Ding)
      end
    end
  end

end