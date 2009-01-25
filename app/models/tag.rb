class Tag
  is_a_neo_node :with_meta_info => true

  property :name, :definition
  index :name, :definition

end
