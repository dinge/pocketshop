class Tools::PhraseMaker::Phrase
  is_a_neo_node do
    db.meta_info true
    # db.validations false
  end

  property :name
  index :name

  has_one(:creator).from(User, :created_tools_phrase_maker_phrases)

  has_n(:triples_as_subject).from(Tools::PhraseMaker::Triple, :phrase_as_subject)
  has_n(:triples_as_predicate).from(Tools::PhraseMaker::Triple, :phrase_as_predicate)
  has_n(:triples_as_object).from(Tools::PhraseMaker::Triple, :phrase_as_object)


  def triples_as(grammar_attribute)
    send('triples_as_%s' % grammar_attribute)
  end

end
