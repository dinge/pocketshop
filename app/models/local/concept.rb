class Local::Concept
  is_a_neo_node :with_meta_info => true
    # :dynamic_properties => true
  
  property :name, :text
  index :name, :text


  has_n(:units)
  has_n(:tags).to(Tag).relation(Tagging)

  # collection_name :concepts
  # fields :name, :text, :created_at, :updated_at, :version
  # has_many :units, :class_name => 'Unit'
  # # has_many :embedded_concepts, :class_name => 'Concept'
end
