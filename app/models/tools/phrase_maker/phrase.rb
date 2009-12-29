class Tools::PhraseMaker::Phrase
  is_a_neo_node do
    db.meta_info true
  end

  property :name
  index :name

  has_one(:creator).from(User, :created_tools_phrase_maker_phrases)

  has_n(:triples_as_subject).to(Tools::PhraseMaker::Triple)
  has_n(:triples_as_predicate).to(Tools::PhraseMaker::Triple)
  has_n(:triples_as_object).to(Tools::PhraseMaker::Triple)
end
