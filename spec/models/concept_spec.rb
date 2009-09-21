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


  describe "#name_words", " through its relationship to word instances" do
    before(:each) do
      delete_all_nodes_from Word, Language, Concept
      I18n.locale = :en

      restart_transaction

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

      restart_transaction
    end

    it "should have words as names" do
      @palace_concept.name_words << @palast << @palace
      @palace_concept.name_words.should include(@palast, @palace)
      @palace_concept.should have(2).name_words
    end



    describe "the method #names", ' for a parametrized access to its international names' do
      before(:each) do
        @palace_concept.name_words << @palast << @palace
      end

      it "should return the localized name", ' using a string or symbol as locale' do
        @palace_concept.localized_name(:en).should == @palace
        @palace_concept.localized_name('de').should == @palast
        @palace_concept.localized_name(:en).to_s.should == 'palace'
        @palace_concept.localized_name('de').to_s.should == 'palast'
        @palace_concept.localized_name(:de_nds).should be_nil

        @palace_concept.name_words << @slot
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

      it "it should only change the name when it's a new one" do
        initial_number_of_words = Word.nodes.size

        first_castle_word = @palace_concept.set_localized_name('castle')

        Word.should have(initial_number_of_words + 1).nodes

        second_castle_word = @palace_concept.set_localized_name('castle')

        Word.should have(initial_number_of_words + 1).nodes
        second_castle_word.should == first_castle_word

        first_palace_word = @palace_concept.set_localized_name(@palace)

        @palace_concept.name.should == @palace.to_s
        Word.should have(initial_number_of_words + 1).nodes
        first_palace_word.should_not == first_castle_word

        first_kindergarten_word = @palace_concept.set_localized_name('kindergarten')

        Word.should have(initial_number_of_words + 2).nodes
        @palace_concept.name.should == 'kindergarten'
        first_kindergarten_word.should_not == first_castle_word
        first_kindergarten_word.should_not == first_palace_word

        second_kindergarten_word = @palace_concept.set_localized_name('kindergarten', :de)
        Word.should have(initial_number_of_words + 3).nodes
        second_kindergarten_word.should_not == first_kindergarten_word
        second_kindergarten_word.language.should == @deutsch

        new_kindergarten_word = Word.new_uniqe_from_language(:name => 'kindergarten', :language => @deutsch)
        third_kindergarten_word = @palace_concept.set_localized_name(new_kindergarten_word)
        Word.should have(initial_number_of_words + 3).nodes
        third_kindergarten_word.should == second_kindergarten_word
        new_kindergarten_word.should == third_kindergarten_word
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

      restart_transaction

      @palace_concept = Concept.new

      @palace   = Word.new(:name => 'palace')
      @castle   = Word.new(:name => 'castle')
      @english  = Language.new(:code => 'en')

      @palast   = Word.new(:name => 'palast')
      @schloss  = Word.new(:name => 'schloss')
      @deutsch  = Language.new(:code => 'de')

      @english.words << @palace << @castle
      @deutsch.words << @palast << @schloss

      restart_transaction
    end

    it "should have localized synonyms", ' next to to its names' do
      @palace_concept.name_words << @palast << @palace
      @palace_concept.synonym_words << @schloss << @castle

      @palace_concept.name_words.should include(@palast, @palace)
      @palace_concept.synonym_words.should include(@schloss, @castle)

      @palace_concept.should have(2).name_words
      @palace_concept.should have(2).synonym_words
    end


    describe "the method #localized_synonyms", ' for a parametrized access to its international synonyms' do
      before(:each) do
        @palace_concept.synonym_words << @schloss << @castle << @palace << @palast
      end

      it "should return the localized synonyms", ' using a string or symbol as locale' do
        @palace_concept.localized_synonyms(:en).should include(@palace, @castle)
        @palace_concept.should have(2).localized_synonyms('en')

        @palace_concept.localized_synonyms('de').should include(@palast, @schloss)
        @palace_concept.should have(2).localized_synonyms(:de)
      end

      it "should return the localized name", ' using language instance' do
        @palace_concept.localized_synonyms(@english).should include(@palace, @castle)
        @palace_concept.localized_synonyms(@deutsch).should include(@palast, @schloss)
      end

      it "#synonyms should return the localized synonyms as seperated string", ' using the current locale' do
        @palace_concept.synonyms.should == 'castle, palace'
        I18n.locale = :de
        @palace_concept.synonyms.should == 'palast, schloss'
      end

      # it "initializing a new concept should also set the localized_name", ' using the current locale' do
      #   @food_concept = Concept.new(:name => 'food')
      #   @food_concept.name.should == 'food'
      # end

    end
  end

end