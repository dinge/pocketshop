class Tag
  is_a_neo_node :with_meta_info => true

  property :name, :text
  index :name, :text

end
