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
      is_a_neo_node :meta_info => true,
                    :dynamic_properties => true
    end

    @somethings = (1..3).map do |i|
      SomeThing.new(:name => "name_#{i}", :age => i)
    end
    @something = @somethings.first

    @otherthing = OtherThing.new
  end

  after(:all) do
    stop_neo4j
  end
end


describe "every object should be able to be a neo node" do
  it_should_behave_like "RoboRails::Neo4j::Node"

  before(:all) do
    class SomeNakedClass; end
  end

  it "the module should be included in all objects" do
    Object.included_modules.should include(RoboRails::Neo4j::Node)
    SomeNakedClass.included_modules.should include(RoboRails::Neo4j::Node)
  end

  it "it's macro method is_a_neo_node should be available to all objects" do
    Object.should respond_to(:is_a_neo_node)
    SomeNakedClass.should respond_to(:is_a_neo_node)
  end

  describe "the Neo4j::NodeMixin", " in a class" do
    context "without calling is_a_neo_node" do
      it "should not be mixed in" do
        SomeNakedClass.included_modules.should_not include(Neo4j::NodeMixin)
        SomeNakedClass.new.should_not be_a_kind_of(Neo4j::NodeMixin)
      end
    end

    context "with calling is_a_neo_node" do
      it "should be mixed in" do
        SomeThing.included_modules.should include(Neo4j::NodeMixin)
        @something.should be_a_kind_of(Neo4j::NodeMixin)
      end
    end
  end
end


describe "a neo node class" do
  it_should_behave_like "RoboRails::Neo4j::Node"

  it "should return it's property names" do
    SomeThing.should have(2).property_names
    SomeThing.property_names.should include(:name)
    SomeThing.property_names.should include(:age)
  end

  describe "loading a collection of nodes" do
    it "they should be all nodes of this class" do
      SomeThing.all_nodes.to_a.size.should be @somethings.size
    end

    it "they should be only instances it's own class" do
      SomeThing.all_nodes.each do |thing|
        thing.should be_an_instance_of(SomeThing)
      end
    end
  end

  describe "loading a single node" do
    context "by id" do
      it "should be able to load a node instance by id" do
        SomeThing.load(1).should == @somethings.first
      end

      it "should raise an exception if loaded node is an instance of an other class" do
        lambda { SomeThing.load(4) }.should raise_error(RoboRails::Neo4j::NotFoundException)
      end

      it "should raise no exception if loaded node is an instance of the same class" do
        lambda { OtherThing.load(4) }.should_not raise_error(RoboRails::Neo4j::NotFoundException)
      end
    end

    context "by other criteria" do
      it "should be able to load it's first created node" do
        SomeThing.first_node.should == @somethings.first
      end

      it "should be able to load it's last created node" do
        SomeThing.last_node.should == @somethings.last
      end
    end

  end


  it "should be able to instantize a node with properties as arguments hash" do
    class DingDong
      is_a_neo_node
      property :name, :age
    end

    dingdong = DingDong.new(:name => 'harras', :age => 46)
    dingdong.name.should == 'harras'
    dingdong.age.should be 46
  end

  describe "using it's lucene index for searching" do
    it "should find it's first matching node and only return this one" do
      pending 'works in dev, check why not in spec'
      # SomeThing.find_first(:name => "name_2").should == @somethings.second
    end

    it "should return nil if non matching find_first is found" do
      SomeThing.find_first(:name => "nothing").should == nil
    end

    it "should fire an exception if non matching find_first! is found" do
      lambda { SomeThing.find_first!(:name => "nothing") }.should raise_error(RoboRails::Neo4j::NotFoundException)
    end
  end

end


describe "a neo node instance" do
  it_should_behave_like "RoboRails::Neo4j::Node"

  context "in general" do
    it "should have the same id as it's neo_node_id" do
      @something.id.should be @something.neo_node_id
    end

    it 'should return #{id}_#{name} calling to_param' do
      @something.to_param.should == "1-name_1"
    end

    it "should be compareable to other things by it's id" do
      (@somethings.first <=> @somethings.last).should be -1
      (@somethings.third <=> @somethings.second).should be 1
      (@somethings.second <=> @somethings.second).should be 0
    end

    it "should return false calling new_record? for form helpers etc." do
      otherthing = OtherThing.new
      otherthing.should_not be_a_new_record
    end
  end


  describe "trying to update! it" do
    before(:each) do
      @something = SomeThing.new(:name => 'harras')
    end

    context "with invalid data" do
      context "like a non existing property" do
        it "the properties should not be changed" do
          lambda { @something.update!(:name => 'dieter', :non_existing_property => 'nono') }.should raise_error(NoMethodError)
          @something.name.should == 'harras'
        end
      end

      context "like something other awfull" do
        it "the properties should not be changed" do
          lambda { @something.update!(:name => 'dieter', :age => DateTime.now) }.should raise_error(NoMethodError)
          @something.name.should == 'harras'
        end
      end
    end

    context "with valid data" do
      it "the properties should be changed" do
        @something.update!(:name => 'dieter')
        @something.name.should == 'dieter'
      end

      it "should not raise an exception" do
        lambda { @something.update!(:name => 'dieter') }.should_not raise_error(NoMethodError)
      end
    end

  end

end


describe "a neo node instance", ' from a class' do
  it_should_behave_like "RoboRails::Neo4j::Node"

  describe "without any special options" do
    context 'like enabled dynamic_properties' do
      it "should not have dynamic properties" do
        @something.should_not respond_to(:unexisting_property)
      end

      it "should raise an exception calling an unexisting property" do
        lambda { @something.unexisting_property }.should raise_error(NoMethodError)
      end
    end

    context 'like enabled meta_info' do
      it "should not have a created_at property" do
        lambda { @something.created_at }.should raise_error(NoMethodError)
      end

      it "should not have a updated_at property" do
        lambda { @something.updated_at }.should raise_error(NoMethodError)
      end

      it "should not have a version property" do
        lambda { @something.version }.should raise_error(NoMethodError)
      end
    end
  end


  context "with enabled dynamic_properties" do
    it "should have dynamic properties" do
      @otherthing.should_not respond_to(:any_dynamic_property)
      @otherthing.should_not respond_to(:any_dynamic_property=)

      @otherthing.any_dynamic_property = "suppe" # uses method_missing
      @otherthing.any_dynamic_property.should == 'suppe'
    end
  end

  context "with enabled meta_info" do
    it "should have the property created_at returning a DateTime" do
      @otherthing.created_at.should be_an_instance_of(DateTime)
    end

    it "should return the DateTime it was created" do
      @otherthing.created_at.day.should == DateTime.now.day
      @otherthing.created_at.hour.should == DateTime.now.hour
    end

    it "should return the DateTime it was updated" do
      @otherthing.updated_at.should be_an_instance_of(DateTime)
    end

    it "should update and return the DateTime it was updated" do
      last_update_at = @otherthing.updated_at
      sleep 2
      @otherthing.suppe = "lecker"

      @otherthing.updated_at.should be_close(DateTime.now, 0.00002)
      @otherthing.updated_at.to_s.should_not == last_update_at.to_s
    end

    it "should return a integer as version" do
      @otherthing.should respond_to(:version)
      @otherthing.version.should be_a_kind_of(Integer)
    end

    it "should increment the version property with every update" do
      old_version = @otherthing.version
      @otherthing.tieger = "hungrig"
      @otherthing.version.should be old_version + 1
    end
  end
end
