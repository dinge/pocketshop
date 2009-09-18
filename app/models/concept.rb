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

  has_n(:attributes).from(Concept::Value::Base, :shared_concepts)
  has_n(:shared_concepts).to(Concept).relationship(Concept::AttributeRelationship)


  has_n(:localized_names).to(Word).relationship(Concept::LocalizedNameRelationship)

  # validates_presence_of :name

  # has_n(:tags).to(Tag).relationship(Tagging)
  # has_n(:basic_tags).relationship(Taggings::Basic)


  def localized_name(locale = I18n.locale)
    locale = locale.code if locale.is_a?(Language)
    word = localized_names.find{ |word| word.language.code == locale.to_s } ? word.name : ''
    # TODO: maybe provide a other way or default language when no language version is found..
  end

  alias :name :localized_name

  def set_localized_name(name, locale = I18n.locale)
    word = Word.new(:name => name)
    language = locale.is_a?(Language) ? locale : Language.find(:code => locale.to_s).first
    word.language = language
    localized_names << word
    word.name
  end

  alias :name= :set_localized_name

end
