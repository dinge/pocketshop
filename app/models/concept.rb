class Concept
  is_a_neo_node do
    options.meta_info = true
    options.validations = true
    options.dynamic_properties = true
  end

  property :name, :text
  index :name, :text

  has_one(:creator).from(User, :created_concepts)
  has_n(:tags).from(Tag, :tagged_concepts)


  validates_presence_of :name

  # has_n(:units)
  # has_n(:tags).to(Tag).relation(Tagging)

  # has_n(:basic_tags).relation(Taggings::Basic)



  def create_new_thing
    
  end

  # collection_name :concepts
  # fields :name, :text, :created_at, :updated_at, :version
  # has_many :units, :class_name => 'Unit'
  # # has_many :embedded_concepts, :class_name => 'Concept'
end
