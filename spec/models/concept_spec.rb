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

  it "has many units" do
    concept = Concept.new(:name => 'soup')
    unit = Concept::Unit.new(:name => 'color')
    concept.units << unit
    concept.units.should be_include unit
  end

  it "should have different types of units" do
    concept = Concept.new(:name => 'soup')
    number = Concept::Unit::Number.new(:name => 'color')
    text = Concept::Unit::Number.new(:name => 'color')

    concept.units << number
    concept.units << text

    concept.units.should be_include number
    concept.units.should be_include text
  end
end