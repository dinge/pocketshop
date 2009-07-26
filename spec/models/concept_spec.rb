require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Concept do
  before(:all) { start_neo4j }
  after(:all) { stop_neo4j }

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
