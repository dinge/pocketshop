require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Concept::Value::Base do
  before(:all) { start_neo4j }
  after(:all) { stop_neo4j }

  before(:each) { Neo4j::Transaction.new }
  after(:each) { Neo4j::Transaction.finish }

  describe 'describe children from Concept::Unit::Base' do

    before(:all) do
      undefine_class :OtherThing

      class OtherThing < Concept::Value::Base
        is_a_neo_node do
          defaults do
            ding 'dong'
          end
        end

        property :another_property
      end

    end


    it 'should inherit some basic properties' do
      OtherThing.properties?(:name, :text).should be_true
    end

    it "should also have it's own properties" do
      OtherThing.property?(:another_property).should be_true
    end

    it 'should inherit some basic association methods' do
      OtherThing.relationships_info[:creator].should be_true
      OtherThing.relationships_info[:shared_concepts].should be_true
      OtherThing.relationships_info[:shared_concepts][:relationship].should == Concept::AttributeRelationship
    end

    it 'should inherit the basic neo node env' do
      neo_node_env = OtherThing.neo_node_env
      neo_node_env.db.validations.should be_true
      neo_node_env.db.meta_info.should be_true
    end

    it "should also have it's own neo node env extensions" do
      neo_node_env = OtherThing.neo_node_env
      neo_node_env.defaults.ding.should == 'dong'
    end
  end

end