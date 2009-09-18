require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Language do
  before(:all) do
    start_neo4j
    Neo4j::Transaction.new
  end

  after(:all) do
    Neo4j::Transaction.finish
    stop_neo4j
  end

  describe "the language class" do
    it "should have some properties" do
      Language.properties?(:name, :code).should be_true
    end
  end



  describe "a language instance" do
    before(:each) do
      @language = Language.new(:code => 'en')
      @palace   = Word.new(:name => 'palace')
      @lock     = Word.new(:name => 'lock')

      @language.words << @palace << @lock
    end


    describe "its relationship to a word" do
      it "it should have relationship to a word" do
        @language.words.should include(@palace, @lock)
        @palace.language.should == @language
      end

      it "the relationships should be the same" do
        language_relationship_ids = @language.relationships.outgoing(:words).map(&:id)
        word_relationship_ids     =
          (@palace.relationships.incoming(:words).map(&:id) + @lock.relationships.incoming(:words).map(&:id)).flatten

        (language_relationship_ids - word_relationship_ids).should be_empty
      end
    end

  end
end