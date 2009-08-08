require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe DingDealer::Neo4j::Relation, :shared => true do
  before(:all) do
    start_neo4j
    undefine_class :SomeThing, :SimpleRelation, :ComplexRelation

    class SimpleRelation
      is_a_neo_relation
    end

    class ComplexRelation
      is_a_neo_relation do
        db.meta_info true
      end

      property :name
    end

    class SomeThing
      is_a_neo_node
      property :name
      has_n(:simple_relations).relationship(SimpleRelation)
      has_n(:complex_relations).relationship(ComplexRelation)
    end

    Neo4j::Transaction.new
  end

  after(:all) do
    ::Neo4j::Transaction.finish
    stop_neo4j
  end
end


describe "every object should be able to be a neo relation" do
  it_should_behave_like "DingDealer::Neo4j::Relation"

  before(:all) do
    class SomeNakedClass; end
  end

  it "the module should be included in all objects" do
    Object.should be_include(DingDealer::Neo4j::Relation)
    SomeNakedClass.should be_include(DingDealer::Neo4j::Relation)
  end


  it "it's macro method is_a_neo_relation should be available to all objects" do
    Object.should respond_to(:is_a_neo_relation)
    SomeNakedClass.should respond_to(:is_a_neo_relation)
  end

  describe "the Neo4j::RelationMixin", " in a class" do
    context "without calling is_a_neo_relation" do
      it "should not be mixed in" do
        SomeNakedClass.should_not be_include(Neo4j::RelationshipMixin)
        SomeNakedClass.new.should_not be_a_kind_of(Neo4j::RelationshipMixin)
      end
    end

    context "with calling is_a_neo_relation" do
      it "should be mixed in" do
        SimpleRelation.should be_include(Neo4j::RelationshipMixin)
      end
    end
  end
end


describe "a neo relation instance", ' from a class' do
  it_should_behave_like "DingDealer::Neo4j::Relation"

  before(:each) do
    @something = SomeThing.new
  end

  after(:each) do
    @something.relationships.each(&:delete)
  end


  context "in general" do
    before(:each) do
      @something.simple_relations << SomeThing.new
      @relation = @something.relationships.both(:simple_relations).to_a.first
    end

    it "should be a kind of Neo4j::RelationMixin" do
      @relation.should be_a_kind_of(Neo4j::RelationshipMixin)
    end

    it "should have the same id as it's neo_relationship_id" do
      @relation.id.should be @relation.neo_relationship_id
    end
  end


  context "without any special db options" do

    before(:each) do
      @something.simple_relations << SomeThing.new
      @relation = @something.relationships.both(:simple_relations).to_a.first
    end

    context 'like enabled meta_info' do
      it "should not have a created_at property" do
        lambda { @relation.created_at }.should raise_error(NoMethodError)
      end

      it "should not have a updated_at property" do
        lambda { @relation.updated_at.should }.should raise_error(NoMethodError)
      end

      it "should not have a version property" do
        lambda { @relation.created_at }.should raise_error(NoMethodError)
      end
    end
  end



  context "with enabled meta_info" do

    before(:each) do
      @something.complex_relations << SomeThing.new
      @relation = @something.relationships.both(:complex_relations).to_a.first
    end

    it "should have the property created_at returning a DateTime" do
      @relation.created_at.should be_an_instance_of(DateTime)
    end

    it "should return the DateTime it was created" do
      @relation.created_at.day.should == DateTime.now.day
      @relation.created_at.hour.should == DateTime.now.hour
    end

    it "should return the DateTime it was updated" do
      @relation.updated_at.should be_an_instance_of(DateTime)
    end

    it "should return a integer as version" do
      @relation.should respond_to(:version)
      @relation.version.should be_a_kind_of(Integer)
    end

    it "should update and return the DateTime it was updated" do
      @relation.name = 'old name'
      last_update_at = @relation.updated_at
      sleep 2
      @relation.name = "new name"

      @relation.updated_at.should be_close(DateTime.now, 0.00002)
      @relation.updated_at.to_s.should_not == last_update_at.to_s
    end

    it "should increment the version property with every update" do
      old_version = @relation.version
      @relation.name = "new name"
      @relation.version.should be old_version + 1
    end
  end
end
