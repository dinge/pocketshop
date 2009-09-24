class Concept
  is_a_neo_node do
    db do
      meta_info true
      # validations true
    end
  end

  has_one(:creator).from(User, :created_concepts)
  has_n(:tags).from(Tag, :tagged_concepts)

  has_n(:attributes).relationship(Concept::AttributeRelationship)
  has_n(:shared_concepts).from(Concept, :attributes).relationship(Concept::AttributeRelationship)

  has_n(:name_words).to(Word).relationship(Concept::LocalizedNameRelationship)
  has_n(:synonym_words).to(Word).relationship(Concept::LocalizedNameRelationship)

  property :name # needed for value object initalization
  property :text

  # index :name, :text
  # validates_presence_of :name
  # has_n(:tags).to(Tag).relationship(Tagging)
  # has_n(:basic_tags).relationship(Taggings::Basic)


  def localized_name(lingo = I18n.locale)
    name_words.find{ |word| word.language.code == lingo.to_s } # TODO: maybe use lucene index here
  end

  def name
    localized_name(I18n.locale).to_s
  end

  def set_localized_name(wording, lingo = I18n.locale)
    new_word = Word.to_word(wording, lingo)
    old_word = localized_name(lingo)
    if new_word != old_word
      relationships.outgoing(:name_words)[old_word].delete if old_word
      name_words << new_word
      new_word
    else
      old_word
    end
  end

  alias :name= :set_localized_name


  def localized_synonyms(lingo = I18n.locale)
    synonym_words.select{ |word| word.language.code == lingo.to_s }.sort_by(&:name)
  end

  def synonyms
    localized_synonyms(I18n.locale).join(', ')
  end

  def synonyms=(synonyms)
  end

end


  # Neo4j.event_handler.add(self)
  # def self.on_relationship_created(relationship)
    # case relationship
    # when Concept::LocalizedNameRelationship
    #   if relationship.relationship_type == :name_words
    #     relationship.start_node.relationships.outgoing(:name_words).nodes.select do |word|
    #       word.language.code == 'en' && word != relationship.end_node
    #     end.each(&:delete)
    #   end
    # end
  # end
