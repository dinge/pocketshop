require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe DingDealer::Neo4j::Node, :shared => true do
  before(:all) do
    start_neo4j
    undefine_class :SomeThing, :OtherThing, :DingDong

    class SomeThing
      is_a_neo_node
      property :name, :age
    end

    class OtherThing
      is_a_neo_node do
        db do
          meta_info true
          dynamic_properties true
          validations true
        end
        defaults do
          property_with_default_value 'default value'
        end
        acl.default_visibility true
      end

      property :property_with_default_value
    end

    Neo4j::Transaction.new

    @somethings = (2..4).map do |i|
      SomeThing.new(:name => "name_#{i}", :age => i)
    end
    @something = @somethings.first

    @otherthing = OtherThing.new
  end

  after(:all) do
    Neo4j::Transaction.finish
    stop_neo4j
  end
end



describe "every object should be able to be a neo node" do
  it_should_behave_like "DingDealer::Neo4j::Node"

  before(:all) do
    undefine_class :SomeNakedClass
    class SomeNakedClass; end
  end

  it "the module should be included in all objects" do
    Object.should be_include(DingDealer::Neo4j::Node)
    SomeNakedClass.should be_include(DingDealer::Neo4j::Node)
  end

  it "it's macro method is_a_neo_node should be available to all objects" do
    Object.should respond_to(:is_a_neo_node)
    SomeNakedClass.should respond_to(:is_a_neo_node)
  end

  describe "the Neo4j::NodeMixin", " in a class" do
    context "without calling is_a_neo_node" do
      it "should not be mixed in" do
        SomeNakedClass.should_not be_include(Neo4j::NodeMixin)
        SomeNakedClass.new.should_not be_a_kind_of(Neo4j::NodeMixin)
      end
    end

    context "with calling is_a_neo_node" do
      it "should be mixed in" do
        SomeThing.should be_include(Neo4j::NodeMixin)
        @something.should be_a_kind_of(Neo4j::NodeMixin)
      end
    end
  end
end



describe "a neo node class" do
  it_should_behave_like "DingDealer::Neo4j::Node"

  it "should return it's property names" do
    SomeThing.should have(2).property_names
    SomeThing.property_names.should be_include(:name)
    SomeThing.property_names.should be_include(:age)
  end

  it "db options should be configurable" do
    db_env = OtherThing.neo_node_env.db
    db_env.should be_a_kind_of(DingDealer::Struct)
    db_env.meta_info.should be_true
    db_env.dynamic_properties.should be_true
    db_env.validations.should be_true
    SomeThing.neo_node_env.db.validations.should_not be_true
  end

  it "acl options should be configurable" do
    OtherThing.neo_node_env.acl.should be_a_kind_of(DingDealer::Struct)
    OtherThing.neo_node_env.acl.default_visibility.should be_true
    SomeThing.neo_node_env.acl.default_visibility.should be_false
  end

  it "default values should be configurable" do
    OtherThing.neo_node_env.defaults.should be_a_kind_of(DingDealer::OpenStruct)
    OtherThing.neo_node_env.defaults.property_with_default_value.should == 'default value'
  end


  describe "the ValueClass" do
    it "should only created once" do
      SomeThing.value_object.should be SomeThing.value_object
      SomeThing.value_object.should_not be OtherThing.value_object
    end
  end


  describe "loading a collection of nodes" do
    it "they should be all nodes of this class" do
      SomeThing.nodes.size.should be @somethings.size
    end

    it "they should be only instances it's own class" do
      SomeThing.nodes.each do |thing|
        thing.should be_an_instance_of(SomeThing)
      end
    end
  end


  describe "validations" do
    it "should include ActiveRecord's validations" do
      undefine_class :SomeNakedClass
      class SomeNakedClass; end
      OtherThing.should be_include(ActiveRecord::Validations)
      OtherThing.should respond_to(:validates_presence_of)
      SomeNakedClass.should_not be_include(ActiveRecord::Validations)
    end
  end


  describe "loading a single node" do
    context "by id" do
      it "should be able to load a node instance by id" do
        SomeThing.load(2).should == @somethings.first
      end

      it "should raise no exception if loaded node is an instance of the same class" do
        lambda { OtherThing.load(5) }.should_not raise_error(DingDealer::Neo4j::Node::NotFoundException)
      end

      it "should raise an exception if loaded node is an instance of an other class" do
        lambda { SomeThing.load!(5) }.should raise_error(DingDealer::Neo4j::Node::NotFoundException)
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


  describe "using it's lucene index for searching" do
    it "should find it's first matching node and only return this one" do
      pending 'works in dev, check why not in spec'
      # SomeThing.find_first(:name => "name_2").should == @somethings.second
    end

    it "should return nil if non matching find_first is found" do
      SomeThing.find_first(:name => "nothing").should == nil
    end

    it "should fire an exception if non matching find_first! is found" do
      lambda { SomeThing.find_first!(:name => "nothing") }.should raise_error(DingDealer::Neo4j::Node::NotFoundException)
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
end




describe "a neo node instance" do
  it_should_behave_like "DingDealer::Neo4j::Node"

  context "in general" do
    it "should have the same id as it's neo_node_id" do
      @something.id.should be @something.neo_node_id
    end

    it 'should return #{id}_#{name} calling to_param' do
      @something.to_param.should == "2-name_2"
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
  it_should_behave_like "DingDealer::Neo4j::Node"

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


    context "like validations" do
      it "should not have the errors accessor" do
        @something.should_not respond_to(:errors)
      end

      it "should respond to valid? as an true returning interface" do
        @something.should be_valid
      end


      describe "the ValueClass" do
        it "should include some needed modules" do
          SomeThing.value_object.should be_include(NodeValidationStubs)

          SomeThing.value_object.should_not be_include(NodeValidations)
          SomeThing.value_object.should_not be_include(ValueObjectExtensions::Validations)
        end
      end


      describe "the ValueObject" do
        it "should respond to valid? as an true returning interface" do
          @something.value_object.should be_valid
        end
      end
    end
  end



  describe "with enabled special options" do
    context "like dynamic_properties" do
      it "should have dynamic properties" do
        @otherthing.should_not respond_to(:any_dynamic_property)
        @otherthing.should_not respond_to(:any_dynamic_property=)

        @otherthing.any_dynamic_property = "suppe" # uses method_missing
        @otherthing.any_dynamic_property.should == 'suppe'
      end
    end

    context "like meta_info" do
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


    context "like default values" do
      it "should use the default value, when no other value is given" do
        otherthing = OtherThing.new
        otherthing.property_with_default_value.should == 'default value'
      end

      it "should not use the default value, when another value is given" do
        otherthing = OtherThing.new(:property_with_default_value => 'custom value')
        otherthing.property_with_default_value.should == 'custom value'
      end

      it "should be possible to overwrite the default value" do
        otherthing = OtherThing.new
        otherthing.property_with_default_value = 'changed value'
        otherthing.property_with_default_value.should == 'changed value'
      end
    end



    context "like validations" do

      before(:all) do
        undefine_class :NakedClassWithValidations
        class NakedClassWithValidations
          is_a_neo_node do
            db.validations true
          end
          property :name

          validates_length_of :name, :minimum => 3
        end
      end


      it "should have methods from ActiveRecord::Validations" do
        naked = NakedClassWithValidations.new
        naked.errors.should be_a_kind_of(ActiveRecord::Errors)
        naked.should respond_to(:errors)
        naked.should respond_to(:valid?)
      end

      context "given a new invalid object" do
        it "calling #valid? should return false" do
          naked = NakedClassWithValidations.new(:name => nil)
          naked.should_not be_valid
          #naked.should have(1).error_on(:name)
        end

        it "but the node should even be saved" do
          naked = NakedClassWithValidations.new(:name => 'ts')
          naked.should_not be_valid
          # naked.should have(1).error_on(:name)
          naked.name.should == 'ts'
        end
      end

      context "given a valid object" do
        it "calling #valid? should return true" do
          naked = NakedClassWithValidations.new(:name => 'total valid')
          naked.should be_valid
        end
      end


      describe "the ValueClass" do
        it "should include some needed modules" do
          NakedClassWithValidations.value_object.should be_include(NodeValidations)
          NakedClassWithValidations.value_object.should be_include(ValueObjectExtensions::Validations)

          NakedClassWithValidations.value_object.should_not be_include(NodeValidationStubs)
        end
      end


      describe "the ValueObject" do

        it "should have methods from ActiveRecord::Validations" do
          value_object = NakedClassWithValidations.value_object.new
          value_object.errors.should be_a_kind_of(ActiveRecord::Errors)
          value_object.should respond_to(:errors)
          value_object.should respond_to(:valid?)
        end


        context "given a invalid object" do
          it "calling #valid? should return false" do
            pending
            value_object = NakedClassWithValidations.value_object.new(:name => nil)
            value_object.should_not be_valid
          end
        end

        context "given a valid object" do
          it "calling #valid? should return true" do
            value_object = NakedClassWithValidations.value_object.new(:name => 'total valid')
            value_object.should be_valid
          end
        end

      end

      it "should not create if invalid" do
        pending
        naked = SomeNakedClass.validated_new(:name => nil)
        naked.should_not be_valid?
      end

    end

  end
end


describe "special validating node create and update methods" do

  before(:all) do
    undefine_class :Cat
    class Cat
      is_a_neo_node do
        db.validations true
      end
      property :name

      validates_length_of :name, :minimum => 3
    end
  end

  context "with valid values" do
    it "new_with_validations should create the node and return it" do
      old_number_of_cats = Cat.nodes.size

      cat = Cat.new_with_validations(:name => "dieter")

      cat.should be_valid
      cat.should be_an_instance_of(Cat)
      Cat.nodes.size.should be old_number_of_cats + 1
    end

    it "update_with_validations should update the node and return it" do
      valid_cat = ::Neo4j::Transaction.run { Cat.new(:name => 'valid_due_create') }


      valid_updated_cat = Cat.update_with_validations(valid_cat, :name => 'valid_due_update')

      valid_updated_cat.should be_valid
      valid_updated_cat.should be_an_instance_of(Cat)
      valid_updated_cat.name.should == 'valid_due_update'

      valid_updated_cat.should be valid_cat
    end
  end


  context "with invalid values" do
    it "new_with_validations should not create the node and return a ValueObject with errors" do
      old_number_of_cats = Cat.nodes.size

      cat = Cat.new_with_validations(:name => 'ts')

      cat.should_not be_valid
      cat.should be_an_instance_of(Neo4j::CatValueObject)
      Cat.nodes.size.should be old_number_of_cats
    end

    it "update_with_validations should not update the node and return a ValueObject with errors" do
      valid_cat = ::Neo4j::Transaction.run { Cat.new(:name => 'valid_due_create') }

      invalid_updated_cat = Cat.update_with_validations(valid_cat, :name => 'ts')

      invalid_updated_cat.should_not be_valid
      invalid_updated_cat.should be_an_instance_of(Neo4j::CatValueObject)
      invalid_updated_cat.name.should == 'ts'

      ::Neo4j::Transaction.run do
        valid_cat.should be_valid
        valid_cat.name.should == 'valid_due_create'
      end
    end
  end
end
