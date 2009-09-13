#! /usr/bin/env jruby
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Concept::Prim::Text do
  before(:all) { start_neo4j }
  after(:all) { stop_neo4j }

  before(:each) { Neo4j::Transaction.new }
  after(:each) { Neo4j::Transaction.finish }

  it "should be part of a concept" do
    text = Concept::Prim::Text.new(:name => 'color')
    concept = Concept.new(:name => 'soup')
    text.concepts << concept
    text.concepts.should include(concept)
    concept.units.should include(text)
  end

  it "should have some default values" do
    text = Concept::Prim::Text.new(:name => 'color')
    text.minimal_length.should == 1
    text.maximal_length.should == 1000
    # text.required.should be_false
  end

  it "the default values should be overwritten in the initalization" do
    number = Concept::Prim::Text.new(:name => 'color', :minimal_length => 10, :maximal_length => 20)
    number.minimal_length.should == 10
    number.maximal_length.should == 20
  end

end
