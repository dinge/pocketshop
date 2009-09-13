require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Concept do
  before(:all) do
    start_neo4j
    Neo4j::Transaction.new
  end

  after(:all) do
    Neo4j::Transaction.finish
    stop_neo4j
  end

  it "has many attributes" do
    concept = Concept.new(:name => 'soup')
    unit    = Concept::Prim::Number.new(:name => 'a special number')
    concept.attributes << unit
    concept.attributes.should be_include unit
  end

  it "should have different types of attributes" do
    concept = Concept.new(:name => 'soup')
    number  = Concept::Prim::Number.new(:name => 'color')
    text    = Concept::Prim::Number.new(:name => 'color')

    concept.attributes << number
    concept.attributes << text

    concept.attributes.should be_include number
    concept.attributes.should be_include text
  end
end