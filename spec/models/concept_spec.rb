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
    concept = Concept.new
    unit    = Concept::Value::Number.new(:name => 'a special number')
    concept.attributes << unit
    concept.attributes.should be_include unit
  end

  it "should have different types of attributes" do
    concept = Concept.new
    number  = Concept::Value::Number.new(:name => 'color')
    text    = Concept::Value::Number.new(:name => 'color')

    concept.attributes << number
    concept.attributes << text

    concept.attributes.should be_include number
    concept.attributes.should be_include text
  end


  describe "localized names", " through its relationship to word instances" do
    before(:each) do
      delete_all_nodes_from Word, Language, Concept
      I18n.locale = :en

      Neo4j::Transaction.finish; Neo4j::Transaction.new

      @palace_concept = Concept.new

      @palace   = Word.new(:name => 'palace')
      @english  = Language.new(:code => 'en')

      @palast   = Word.new(:name => 'palast')
      @deutsch  = Language.new(:code => 'de')

      @slot     = Word.new(:name => 'slot')
      @platt    = Language.new(:code => 'de_nds')

      @swenska  = Language.new(:code => 'se')

      @palace.language  = @english
      @palast.language  = @deutsch
      @slot.language    = @platt

      Neo4j::Transaction.finish; Neo4j::Transaction.new
    end

    it "should have localized names" do
      @palace_concept.localized_names << @palast << @palace
      @palace_concept.localized_names.should include(@palast, @palace)
      @palace_concept.should have(2).localized_names
    end



    describe "the method #localized_name", ' for a parametrized access to its international names' do
      before(:each) do
        @palace_concept.localized_names << @palast << @palace
      end

      it "should return the localized name", ' using a string or symbol as locale' do
        @palace_concept.localized_name(:en).should == @palace
        @palace_concept.localized_name('de').should == @palast
        @palace_concept.localized_name(:en).to_s.should == 'palace'
        @palace_concept.localized_name('de').to_s.should == 'palast'
        @palace_concept.localized_name(:de_nds).should be_nil

        @palace_concept.localized_names << @slot
        @palace_concept.localized_name(:de_nds).to_s.should == 'slot'
      end

      it "should return the localized name", ' using language instance' do
        @palace_concept.localized_name(@english).should == @palace
        @palace_concept.localized_name(@deutsch).should == @palast
        @palace_concept.localized_name(@english).to_s.should == 'palace'
        @palace_concept.localized_name(@deutsch).to_s.should == 'palast'
      end

      it "#name should return the localized_name", ' using the current local' do
        @palace_concept.name.should == 'palace'
        I18n.locale = :de
        @palace_concept.name.should == 'palast'
      end

      it "initializing a new concept should also set the localized_name", ' using the current locale' do
        @food_concept = Concept.new(:name => 'food')
        @food_concept.name.should == 'food'
      end
    end



    describe "setting the localized_name", ' using the given locale' do
      it "#set_localized_name should set the name" do
        @palace_concept.set_localized_name('castle')
        @palace_concept.name.should == 'castle'

        @palace_concept.set_localized_name('superdickeshaus', :de)
        @palace_concept.localized_name(:de).to_s.should == 'superdickeshaus'

        I18n.locale = :de_nds
        @palace_concept.set_localized_name(@slot)
        @palace_concept.name.should == @slot.to_s

        @palace_concept.set_localized_name('slott', @swenska)
        I18n.locale = :se
        @palace_concept.name.should == 'slott'
      end


      it "#name= should set the name", ' using the current locale' do
        @palace_concept.name = 'castle'
        @palace_concept.name.should == 'castle'

        I18n.locale = :de
        @palace_concept.name = 'superdickeshaus'
        @palace_concept.name.should == 'superdickeshaus'

        I18n.locale = :en
        @palace_concept.name.should == 'castle'

        @palace_concept.name = @palace
        @palace_concept.name.should == 'palace'
      end
    end

  end

  describe "localized synonyms", " through its relationship to word instances" do
    before(:each) do
      delete_all_nodes_from Word, Language, Concept
      I18n.locale = :en

      Neo4j::Transaction.finish; Neo4j::Transaction.new

      @palace_concept = Concept.new

      @palace   = Word.new(:name => 'palace')
      @castle   = Word.new(:name => 'castle')
      @english  = Language.new(:code => 'en')

      @palast   = Word.new(:name => 'palast')
      @schloss  = Word.new(:name => 'schloss')
      @deutsch  = Language.new(:code => 'de')

      @english.words << @palace << @castle
      @deutsch.words << @palast << @schloss

      Neo4j::Transaction.finish; Neo4j::Transaction.new
    end

    it "should have localized synonyms", ' nexto to its names' do
      pending
      @palace_concept.localized_names << @palast << @palace
      # debugger
      @palace_concept.localized_synonyms << @schloss << @castle

      @palace_concept.localized_names.should include(@palast, @palace)
      @palace_concept.localized_synonyms.should include(@schloss, @castle)

      @palace_concept.should have(2).localized_names
      @palace_concept.should have(2).localized_synonyms
    end

    describe "the method #localized_synonyms", ' for a parametrized access to its international synonyms' do
      before(:each) do
        @palace_concept.localized_synonyms << @schloss << @castle
      end

      it "should return the localized synonyms", ' using a string or symbol as locale' do
        pending
        @palace_concept.localized_synonyms << @palast << @palace
        @palace_concept.localized_synonyms(:en).should include(@palace, @castle)
        @palace_concept.should have(2).localized_synonyms('en')

        @palace_concept.localized_synonyms('de').should include(@palast, @schloss)
        @palace_concept.should have(2).localized_synonyms(:de)
      end

      # it "should return the localized name", ' using language instance' do
      #   @palace_concept.localized_name(@english).should == 'palace'
      #   @palace_concept.localized_name(@deutsch).should == 'palast'
      # end
      # 
      # it "#name should return the localized_name", ' using the current local' do
      #   @palace_concept.name.should == 'palace'
      #   I18n.locale = :de
      #   @palace_concept.name.should == 'palast'
      # end
      # 
      # it "initializing a new concept should also set the localized_name", ' using the current locale' do
      #   pending
      #   @food_concept = Concept.new(:name => 'food')
      #   @food_concept.name.should == 'food'
      # end

    end

  end

    #
    # describe "setting the localized_name", ' using the given locale' do
    #
    #   it "#set_localized_name should set the name" do
    #     @palace_concept.set_localized_name('castle')
    #     @palace_concept.name.should == 'castle'
    #
    #     @palace_concept.set_localized_name('superdickeshaus', :de)
    #     @palace_concept.localized_name(:de).should == 'superdickeshaus'
    #
    #     I18n.locale = :de_nds
    #     @palace_concept.set_localized_name('dickes hus')
    #     @palace_concept.name.should == 'dickes hus'
    #
    #     @palace_concept.set_localized_name('slott', @swenska)
    #     I18n.locale = :se
    #     @palace_concept.name.should == 'slott'
    #   end
    #
    #
    #   it "#name= should set the name", ' using the current locale' do
    #     @palace_concept.name = 'castle'
    #     @palace_concept.name.should == 'castle'
    #
    #     I18n.locale = :de
    #     @palace_concept.name = 'superdickeshaus'
    #     @palace_concept.name.should == 'superdickeshaus'
    #
    #     I18n.locale = :en
    #     @palace_concept.name.should == 'castle'
    #   end
    #
    # end



end