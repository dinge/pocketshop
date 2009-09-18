class Word::LanguageRelationship
  is_a_neo_relation do
    db.meta_info true
  end

  property :language_code
end