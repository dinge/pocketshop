require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Concept::AttributeRelationship do
  before(:all) { start_neo4j }
  after(:all) { stop_neo4j }

  before(:each) { Neo4j::Transaction.new }
  after(:each) { Neo4j::Transaction.finish }


  describe "relationships" do
    before(:each) do
      delete_all_nodes_from Concept, Concept::Value::Text, Concept::Value::Number

      @whisky     = Concept.new(:name => 'whisky')
      @distillery = Concept.new(:name => 'distillery')
      @color      = Concept.new(:name => 'color')
      @rocket     = Concept.new(:name => 'rocket')

      @taste      = Concept::Value::Text.new(:name => 'taste')
      @age        = Concept::Value::Number.new(:name => 'age')
      @speed      = Concept::Value::Number.new(:name => 'speed')
    end

    context "between concepts and value instances" do
      before(:each) do
        @whisky.attributes    << @taste
        @age.shared_concepts  << @whisky # as alternative to @whisky.attributes << @age
      end

      it "a concept instance should value instances as attributes" do
        @whisky.attributes.should include(@taste, @age)
        @whisky.should have(2).attributes
      end

      it "a value instance should have the same relationship to the concept instance as a shared_concept" do
        @taste.shared_concepts.should include(@whisky)
        @age.shared_concepts.should include(@whisky)
      end

      it "a value instance should have relationships to other concepts" do
        @age.shared_concepts << @rocket
        @age.shared_concepts.should include(@rocket, @whisky)
      end

      it "a concept instance should not have relationships to other undefined value instances" do
        @whisky.attributes.should_not include(@speed)
      end


      context "in comparison of the relationships" do
        it "the relationship instances should be the same" do
          concept_relationships =  @whisky.relationships.outgoing(:attributes).to_a
          value_relationships   =
            @taste.relationships.incoming(:attributes).to_a + @age.relationships.incoming(:attributes).to_a

          concept_relationships.should == value_relationships
          concept_relationships.should be_any
          value_relationships.should be_any
        end

        it "the relationships should be directed" do
          @whisky.relationships.incoming(:attributes).to_a.should be_empty
          @taste.relationships.outgoing(:attributes).to_a.should be_empty
          @age.relationships.outgoing(:attributes).to_a.should be_empty
        end
      end

    end


    context "between concept instances and other concept instances" do
      it "a concept should have relationships to other concepts as an attribute" do
        @whisky.attributes << @distillery

        @whisky.attributes.should include(@distillery)
      end
    end


    context "between concept instances and a mixture of other concept instances and value instances" do
      before(:each) do
        @whisky.attributes << @distillery << @taste
      end

      it "a concept instance should have relationships to a mixture of other concept and values instances as attributes " do
        @whisky.attributes.should include(@distillery, @taste)
        @whisky.should have(2).attributes
      end

      it "a concept instance should have the same relationship to the concept instance as a shared_concept" do
        @color.shared_concepts << @whisky

        @distillery.shared_concepts.should include(@whisky)
        @color.shared_concepts.should include(@whisky)
        @whisky.attributes.should include(@color, @distillery)
      end

      context "in comparison of the relationships" do
        it "the relationship instances should be the same" do
          concept_relationship_ids          = @whisky.relationships.outgoing(:attributes).map(&:id)
          value_relationship_ids            = @taste.relationships.incoming(:attributes).map(&:id)
          embedded_concept_relationship_ids = @distillery.relationships.incoming(:attributes).map(&:id)

          (concept_relationship_ids - (value_relationship_ids + embedded_concept_relationship_ids)).should be_empty

          concept_relationship_ids.should be_any
          value_relationship_ids.should be_any
          embedded_concept_relationship_ids.should be_any
        end

        it "the relationships should be directed" do
          @whisky.relationships.incoming(:attributes).to_a.should be_empty
          @taste.relationships.outgoing(:attributes).to_a.should be_empty
          @distillery.relationships.outgoing(:attributes).to_a.should be_empty
        end

      end

    end
  end


  describe "creating relationships with the shaping values in the relationship" do
    before(:each) do
      delete_all_nodes_from Concept, Concept::Value::Text, Concept::Value::Number

      @whisky     = Concept.new(:name => 'whisky')
      @distillery = Concept.new(:name => 'distillery')
      @rocket     = Concept.new(:name => 'rocket')

      @taste      = Concept::Value::Text.new(:name => 'taste')
      @age        = Concept::Value::Number.new(:name => 'age')
      @speed      = Concept::Value::Number.new(:name => 'speed')
    end

    it "should " do
      # @whisky.attributes << @age
      # # @whisky.class::Defaults.keys
      # #debugger
      # @whisky.relationships.outgoing(:attributes)[@age]
      # 
    end


  end

end