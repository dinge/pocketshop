class Word
  is_a_neo_node do
    db do
      meta_info true
      validations true
    end
  end

  property :name
  index :name

  has_one(:language).from(Language, :words)
  index 'language.code'

  has_n(:names_in_concepts).from(Concept, :names)
  has_n(:synonyms_in_concepts).from(Concept, :localized_synonym_words)

  # validates_presence_of :name


  def to_s
    name.to_s
  end

  def self.to_code(word_or_string)
    word_or_string.to_s
  end

  def self.to_word(word_or_string, locale = I18n.locale)
    case word_or_string
    when Word;    word_or_string
    else String;  Word.new_uniqe_from_language(:name => word_or_string, :language => Language.to_language(locale))
    end
  end

  def self.new_uniqe_from_language(properties)
    Neo4j::Transaction.run do
      Word.indexer.lucene_index.commit
      find_first(:name => properties[:name], 'language.code' => properties[:language].to_s ) || new(properties)
    end
  end
end
