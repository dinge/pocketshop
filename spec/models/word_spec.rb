require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Word do
  before(:all) do
    start_neo4j
    Neo4j::Transaction.new
  end

  after(:all) do
    Neo4j::Transaction.finish
    stop_neo4j
  end

  describe "the word class" do
    it "should have some properties" do
      Word.properties?(:name).should be_true
    end
  end



  describe "a word instance" do
    before(:each) do
      @palace   = Word.new(:name => 'palace')
      @language = Language.new(:code => 'en')

      @palace.language = @language
    end


    describe "its relationship to a language" do
      it "it should have relationship to a language" do
        @palace.language.should == @language
        @language.words.should include(@palace)
      end

      it "the relationships should be the same" do
        @palace.relationships.incoming(:words).to_a.should == @language.relationships.outgoing(:words).to_a
      end
    end

  end
end