require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Concept::Unit do
  before(:all) { start_neo4j }
  after(:all) { stop_neo4j }

  before(:each) { Neo4j::Transaction.new }
  after(:each) { Neo4j::Transaction.finish }


  it "should be part of a concept" do
    unit = Concept::Unit.new(:name => 'color')
    concept = Concept.new(:name => 'soup')
    unit.concept = concept
    unit.concept.should == concept
  end

end
