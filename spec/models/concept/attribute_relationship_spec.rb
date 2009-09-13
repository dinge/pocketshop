require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Concept::AttributeRelationship do
  before(:all) { start_neo4j }
  after(:all) { stop_neo4j }

  before(:each) { Neo4j::Transaction.new }
  after(:each) { Neo4j::Transaction.finish }


  describe "relationships" do
    before(:each) do
      delete_all_nodes_from Concept, Concept::Value::Text, Concept::Value::Number

      @whisky         = Concept.new(:name => 'whisky')
      @distillery     = Concept.new(:name => 'distillery')
      @rocket         = Concept.new(:name => 'rocket')

      @taste          = Concept::Value::Text.new(:name => 'taste')
      @age            = Concept::Value::Number.new(:name => 'age')
      @speed          = Concept::Value::Number.new(:name => 'speed')
    end

    context "between concepts and value instances" do
      before(:each) do
        @whisky.attributes << @taste
        @age.shared_concepts << @whisky
      end

      it "a concept instance should value instances as attributes" do
        @whisky.attributes.should include(@taste)
        @whisky.attributes.should include(@age)
        @whisky.should have(2).attributes
      end

      it "a value instance should have the same relationship to the concept instance" do
        @taste.shared_concepts.should include(@whisky)
        @age.shared_concepts.should include(@whisky)
      end

      it "a value instance should have relationships to other concepts" do
        @age.shared_concepts << @rocket
        @age.shared_concepts.should include(@rocket)
        @age.shared_concepts.should include(@whisky)
      end

      it "a concept instance should not have relationships to other undefined value instances" do
        @whisky.attributes.should_not include(@speed)
      end
    end


    context "between concept instances and other concept instances" do
      it "a concept should have relationships to other concepts as an attribute" do
        @whisky.attributes << @distillery

        @whisky.attributes.should include(@distillery)
      end
    end


    context "between concept instances and a mixture of other concept instances and value instances" do
      it "a concept instance should have relationships to a mixture of other concept and values instances as attributes " do
        @whisky.attributes << @distillery << @taste

        @whisky.attributes.should include(@distillery)
        @whisky.attributes.should include(@taste)
        @whisky.should have(2).attributes
      end
    end


  end
end