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
    # traverse.incoming('triples_as_%s' % grammar_attribute)
  end

  def triples
    traverse.incoming(:phrase_as_subject, :phrase_as_object, :phrase_as_predicate)
  end

  def self.filter_by_grammar_attribute(phrases, grammar_attribute)
    phrases.select do |phrase|
      phrase.triples_as(grammar_attribute).to_a.any?
    end
  end

  # def self.by_grammar_attribute(grammar_attribute)
  #   []
  # end

end
