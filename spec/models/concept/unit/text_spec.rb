require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Concept::Unit::Text do
  before(:all) { start_neo4j }
  after(:all) { stop_neo4j }


  it "should be part of a concept" do
    text = Concept::Unit::Text.new(:name => 'color')
    concept = Concept.new(:name => 'soup')
    text.concept = concept
    text.concept.should == concept
  end

  it "should have some default values" do
    text = Concept::Unit::Text.new(:name => 'color')
    text.minimal_length.should == 1
    text.maximal_length.should == 1000
    text.required.should be_false
  end

end
