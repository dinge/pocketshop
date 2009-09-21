class Concept
  is_a_neo_node do
    db do
      meta_info true
      validations true
    end
  end

  # property :name, :text
  # index :name, :text

  has_one(:creator).from(User, :created_concepts)
  has_n(:tags).from(Tag, :tagged_concepts)

  has_n(:attributes).relationship(Concept::AttributeRelationship)
  has_n(:shared_concepts).from(Concept, :attributes).relationship(Concept::AttributeRelationship)

  has_n(:names).to(Word).relationship(Concept::LocalizedNameRelationship)
  has_n(:localized_synonym_words).to(Word).relationship(Concept::LocalizedNameRelationship)


  # validates_presence_of :name

  # has_n(:tags).to(Tag).relationship(Tagging)
  # has_n(:basic_tags).relationship(Taggings::Basic)


  def localized_name(locale = I18n.locale)
    names.find{ |word| word.language.code == locale.to_s }
  end

  def name
    localized_name(I18n.locale).to_s
  end

  def set_localized_name(wording, locale = I18n.locale)
    new_word = Word.to_word(wording, locale)
    old_word = localized_name(locale)
    if new_word != old_word
      relationships.outgoing(:names)[old_word].delete if old_word
      names << new_word
      new_word
    else
      old_word
    end
  end

  alias :name= :set_localized_name



        # def #{method}(value = (empty_argument = true; nil), &block)
        #   if !empty_argument


  def localized_synonyms(locale = I18n.locale)
    locale = locale.code if locale.is_a?(Language)
    # localized_synonym_words.find{ |word| word.language.code == locale.to_s }
localized_synonym_words
  end


end
