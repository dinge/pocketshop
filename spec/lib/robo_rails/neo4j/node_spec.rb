require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe RoboRails::Neo4j::Node, :shared => true do
  before(:all) do
    start_neo4j
    undefine_class :SomeThing, :OtherThing

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


describe "RoboRails::Neo4j::Node class methods" do
  it_should_behave_like "RoboRails::Neo4j::Node"

  it "should load a node" do
    SomeThing.load(1).should == @some_things.first
  end

  it "should fire a exception if loaded node is instance of an other class" do
    lambda { SomeThing.load(4) }.should raise_error(RoboRails::Neo4j::NotFoundException)
    lambda { OtherThing.load(4) }.should_not raise_error(RoboRails::Neo4j::NotFoundException)
  end

  it "should mixin neo4j node" do
    SomeThing.new.should be_a_kind_of(Neo4j::NodeMixin)
  end

  it "should return it's property names" do
    SomeThing.should have(2).property_names
    SomeThing.property_names.should include(:name)
    SomeThing.property_names.should include(:age)
  end

  it "should load all nodes of this class" do
    SomeThing.all_nodes.to_a.size.should == 3
    SomeThing.all_nodes.each do |thing|
      thing.should be_instance_of(SomeThing)
    end
  end

  it "should load it's first created node" do
    SomeThing.first_node.should == @some_things.first
  end

  it "should load it's last created node" do
    SomeThing.last_node.should == @some_things.last
  end

  it "should find it's first matching node and only return this one" do
    pending 'works in dev, check why not in spec'
    # puts SomeThing.all_nodes.map(&:name).inspect
    #puts    SomeThing.find_first(:name => "name_2").name
    # SomeThing.find_first(:name => "name_2").should == @some_things.second
  end

  it "should return nil if non mathing is found" do
    SomeThing.find_first(:name => "nothing").should == nil
  end

  it "should fire an exception if non mathing is found" do
    lambda { SomeThing.find_first!(:name => "nothing") }.should raise_error(RoboRails::Neo4j::NotFoundException)
  end

end


describe "RoboRails::Neo4j::Node is_a_neo_node without special options" do
  it_should_behave_like "RoboRails::Neo4j::Node"

  it "should not have dynamic properties if not specified" do
    lambda { @some_thing.unexisting_property }.should raise_error(NoMethodError)
    @some_thing.should_not respond_to(:unexisting_property)
  end

  it "should not have created_at property if not specified" do
    lambda { @some_thing.created_at }.should raise_error(NoMethodError)
  end

  it "should not have updated_at property if not specified" do
    lambda { @some_thing.updated_at }.should raise_error(NoMethodError)
  end

  it "should not have version property if not specified" do
    lambda { @some_thing.version }.should raise_error(NoMethodError)
  end
end


describe "RoboRails::Neo4j::Node is_a_neo_node with special options" do
  it_should_behave_like "RoboRails::Neo4j::Node"


  it "should have dynamic properties if specified" do
    @other_thing.should_not respond_to(:any_dynamic_property)
    @other_thing.should_not respond_to(:any_dynamic_property=)

    @other_thing.any_dynamic_property = "suppe" # uses method_missing
    @other_thing.any_dynamic_property.should == 'suppe'
  end

  it "should have the property created_at returning a DateTime" do
    @other_thing.created_at.should be_instance_of(DateTime)
  end

  it "should return the date and time it was created" do
    @other_thing.created_at.day.should == DateTime.now.day
    @other_thing.created_at.hour.should == DateTime.now.hour
  end

  it "should have the property updated_at returning a DateTime" do
    @other_thing.updated_at.should be_instance_of(DateTime)
  end

  it "should return the date and time it was updated" do
    pending "fails sometimes, check"
    # last_update_at = @other_thing.updated_at.to_s.dup
    # sleep 3
    # @other_thing.suppe = "lecker"
    # @other_thing.updated_at.to_s.should == DateTime.now.to_s
    # @other_thing.updated_at.to_s.should != last_update_at
  end

  it "should have a version property if specified returning a integer" do
    @other_thing.should respond_to(:version)
  end

  it "should increment the version property with every update" do
    old_version = @other_thing.version
    @other_thing.tieger = "hungrig"
    @other_thing.version.should be old_version + 1
  end

end


describe "RoboRails::Neo4j::Node instance methods" do
  it_should_behave_like "RoboRails::Neo4j::Node"

  it "should have it's id be the same as it's neo_node_id" do
    @some_thing.id.should be @some_thing.neo_node_id
  end

  it "should return the id and the name calling to_param" do
    @some_thing.to_param.should == "1-name_1"
  end

  it "should by compare each things by each ids" do
    pending "don't know how to test"
    # @some_things.first.should be >= @some_things.second
    # @some_things.second.should be >= @some_things.third
  end

  it "should throw an exception when updating in transaction and it fails, the properties should then not be changed" do
    pending "implement this"
    # something = SomeThing.new(:name => 'harras')
    # something.name.should == 'harras'
    # something.update!(:name => 'dieter', :non_existing_property => 'nono')
    # something.name.should == 'harras'
  end

  it "should return false calling new_record?" do
    something = SomeThing.new
    something.new_record?.should be false
  end

  it "should be possible to instantize a node woth properties as arguments hash" do
    something = SomeThing.new(:name => 'harras', :age => 46)
    something.name.should == 'harras'
    something.age.should be 46
  end

end
