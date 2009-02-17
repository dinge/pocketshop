class Local::Concept
  is_a_neo_node :meta_info => true
    # :dynamic_properties => true

  property :name, :text
  index :name, :text

  has_one(:creator).from(Local::User, :created_concepts)
  has_n(:tags).from(Tag, :tagged_concepts)


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
