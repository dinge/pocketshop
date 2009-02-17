require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe RoboRails::Neo4j::Node, :shared => true do
  before(:all) do
    start_neo4j
    undefine_class :SomeThing, :OtherThing, :DingDong

    class SomeThing
      is_a_neo_node
      property :name, :age
    end

    class OtherThing
      is_a_neo_node :with_meta_info => true,
                    :dynamic_properties => true
    end

    @some_things = (1..3).map do |i|
      SomeThing.new(:name => "name_#{i}", :age => i)
    end
    @some_thing = @some_things.first

    @other_thing = OtherThing.new
  end

  after(:all) do
    stop_neo4j
  end
end


describe "a neo node class" do
  it_should_behave_like "RoboRails::Neo4j::Node"

  it "it's macro method is_a_neo_node should be available to all objects" do
    Object.included_modules.should include(RoboRails::Neo4j::Node)
    Object.should respond_to(:is_a_neo_node)
  end

  it "should have mixed in Neo4j::NodeMixin" do
    SomeThing.included_modules.should include(Neo4j::NodeMixin)
    @some_thing.should be_a_kind_of(Neo4j::NodeMixin)
  end

  it "should be able to load a node instance" do
    SomeThing.load(1).should == @some_things.first
  end

  it "should fire an exception if loaded node is an instance of an other class" do
    lambda { SomeThing.load(4) }.should raise_error(RoboRails::Neo4j::NotFoundException)
    lambda { OtherThing.load(4) }.should_not raise_error(RoboRails::Neo4j::NotFoundException)
  end

  it "should return it's property names" do
    SomeThing.should have(2).property_names
    SomeThing.property_names.should include(:name)
    SomeThing.property_names.should include(:age)
  end

  it "should be able to load all nodes of this class, and ony this" do
    SomeThing.all_nodes.to_a.size.should be 3
    SomeThing.all_nodes.each do |thing|
      thing.should be_an_instance_of(SomeThing)
    end
  end

  it "should be able to load it's first created node" do
    SomeThing.first_node.should == @some_things.first
  end

  it "should be able to load it's last created node" do
    SomeThing.last_node.should == @some_things.last
  end

  it "should find it's first matching node and only return this one" do
    pending 'works in dev, check why not in spec'
    # SomeThing.find_first(:name => "name_2").should == @some_things.second
  end

  it "should return nil if non matching first_node is found" do
    SomeThing.find_first(:name => "nothing").should == nil
  end

  it "should fire an exception if non matching first_node! is found" do
    lambda { SomeThing.find_first!(:name => "nothing") }.should raise_error(RoboRails::Neo4j::NotFoundException)
  end

  it "should be able to instantize a node with properties as arguments hash" do
    class DingDong
      is_a_neo_node
      property :name, :age
    end

    otherthing = DingDong.new(:name => 'harras', :age => 46)
    otherthing.name.should == 'harras'
    otherthing.age.should be 46
  end

end


describe "a neo node instance", ' in general' do
  it_should_behave_like "RoboRails::Neo4j::Node"

  it "should have it's id be the same as it's neo_node_id" do
    @some_thing.id.should be @some_thing.neo_node_id
  end

  it 'should return #{id}_#{name} calling to_param' do
    @some_thing.to_param.should == "1-name_1"
  end

  it "should be compareable to other things by it's id" do
    (@some_things.first <=> @some_things.last).should be -1
    (@some_things.third <=> @some_things.second).should be 1
    (@some_things.second <=> @some_things.second).should be 0
  end

  context "should raise an exception when trying to update!" do
    it "with a non existing property, the properties should then not be changed" do
      something = SomeThing.new(:name => 'harras')
      lambda { something.update!(:name => 'dieter', :non_existing_property => 'nono') }.should raise_error(NoMethodError)
      something.name.should == 'harras'
    end

    it "with something other awfull, the properties should then not be changed" do
      something = SomeThing.new(:name => 'harras')
      lambda { something.update!(:name => 'dieter', :age => DateTime.now) }.should raise_error(NoMethodError)
      something.name.should == 'harras'
    end
  end

  it "should not raise an exception when update! works, the properties should then be changed" do
    something = SomeThing.new(:name => 'harras')
    lambda { something.update!(:name => 'dieter') }.should_not raise_error(NoMethodError)
    something.name.should == 'dieter'
  end

  it "should return false calling new_record?" do
    otherthing = OtherThing.new
    otherthing.should_not be_a_new_record
  end

end


describe "a neo node instance", " without special options" do
  it_should_behave_like "RoboRails::Neo4j::Node"

  it "should not have dynamic properties" do
    lambda { @some_thing.unexisting_property }.should raise_error(NoMethodError)
    @some_thing.should_not respond_to(:unexisting_property)
  end

  it "should not have a created_at property" do
    lambda { @some_thing.created_at }.should raise_error(NoMethodError)
  end

  it "should not have a updated_at property" do
    lambda { @some_thing.updated_at }.should raise_error(NoMethodError)
  end

  it "should not have a version property" do
    lambda { @some_thing.version }.should raise_error(NoMethodError)
  end

end


describe "a neo node instance", " with the option" do
  it_should_behave_like "RoboRails::Neo4j::Node"

  context "dynamic_properties true" do
    it "should have dynamic properties" do
      @other_thing.should_not respond_to(:any_dynamic_property)
      @other_thing.should_not respond_to(:any_dynamic_property=)

      @other_thing.any_dynamic_property = "suppe" # uses method_missing
      @other_thing.any_dynamic_property.should == 'suppe'
    end
  end

  context "with_meta_info true" do
    it "should have the property created_at returning a DateTime" do
      @other_thing.created_at.should be_an_instance_of(DateTime)
    end

    it "should return the DateTime it was created" do
      @other_thing.created_at.day.should == DateTime.now.day
      @other_thing.created_at.hour.should == DateTime.now.hour
    end

    it "should have the property updated_at returning a DateTime" do
      @other_thing.updated_at.should be_an_instance_of(DateTime)
    end

    it "should updated and return the DateTime it was updated" do
      last_update_at = @other_thing.updated_at
      sleep 1
      @other_thing.suppe = "lecker"
      @other_thing.updated_at.to_s.should == DateTime.now.to_s
      @other_thing.updated_at.to_s.should_not == last_update_at.to_s
    end

    it "should have a version property returning a integer" do
      @other_thing.should respond_to(:version)
      @other_thing.version.should be_a_kind_of(Integer)
    end

    it "should increment the version property with every update" do
      old_version = @other_thing.version
      @other_thing.tieger = "hungrig"
      @other_thing.version.should be old_version + 1
    end
  end

end
