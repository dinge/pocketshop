class Language
  is_a_neo_node do
    db do
      meta_info true
      validations true
    end
  end

  property :code, :name
  index :code, :name

  has_n(:words).to(Word).relationship(Word::LanguageRelationship)
  validates_presence_of :name

  def to_s
    code
  end

  def self.to_code(lang)
    lang.to_s
  end

  def self.to_language(lang)
    case lang
    when Language;        lang
    when String, Symbol;  find_first(:code => lang)
    end
  end

end