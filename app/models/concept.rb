class Concept
  is_a_neo_node :with_meta_info => true
    # :dynamic_properties => true
  
  property :name, :definition
  index :name, :definition


  has_n(:units)


  # collection_name :concepts
  # fields :name, :text, :created_at, :updated_at, :version
  # has_many :units, :class_name => 'Unit'
  # # has_many :embedded_concepts, :class_name => 'Concept'
end
