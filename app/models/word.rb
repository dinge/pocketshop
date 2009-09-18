class Word
  is_a_neo_node do
    db do
      meta_info true
      validations true
    end
  end

  property :name#, :language_code
  index :name#, :language_code

  has_one(:language).from(Language, :words)

  validates_presence_of :name
end
