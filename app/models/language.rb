class Language
  is_a_neo_node do
    db do
      meta_info true
      validations true
    end
  end

  property :code, :name

  has_n(:words).to(Word).relationship(Word::LanguageRelationship)
  validates_presence_of :name
end