class Tools::PhraseMaker::Triple# < ActiveRecord::Base
  is_a_neo_node do
    db.meta_info true
    # db.validations false
  end

  GrammarAttributes = %w(subject predicate object)

  has_one(:creator).from(User, :created_tools_phrase_maker_triples)
  has_one(:phrase_as_subject).to(Tools::PhraseMaker::Phrase)
  has_one(:phrase_as_predicate).to(Tools::PhraseMaker::Phrase)
  has_one(:phrase_as_object).to(Tools::PhraseMaker::Phrase)


  def phrase_as(grammar_attribute)
    send('phrase_as_%s' % grammar_attribute)
  end

  module SharedMethods
    def subject_name; end
    def predicate_name; end
    def object_name;end

    def name
      [subject_name, predicate_name, object_name].join(' ')
    end
  end

  include SharedMethods


  def subject_name
    phrase_as_subject.name   if phrase_as_subject
  end

  def predicate_name
    phrase_as_predicate.name if phrase_as_predicate
  end

  def object_name
    phrase_as_object.name    if phrase_as_object
  end

end
