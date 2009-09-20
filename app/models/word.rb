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

  has_n(:names_in_concepts).from(Concept, :localized_names)
  has_n(:synonyms_in_concepts).from(Concept, :localized_synonym_words)

  # validates_presence_of :name


  def to_s
    name.to_s
  end

  def self.new_uniqe_from_language(properties)
    Neo4j::Transaction.run do
      find_first(:name => properties[:name], 'language.code' => properties[:language].to_s ) || new(properties)
    end
  end

end
