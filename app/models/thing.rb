class Thing
  is_a_neo_node :with_meta_info => true,
                :dynamic_properties => true
  
  property :name, :text
  index :name, :text
  
  
  # collection_name :things
  # fields :name, :text, :created_at, :updated_at, :version, :rating, :tags
  # 
  # 
  # works_with_dynamic_attributes
  # 
  # InvisibleAttributesNames = [:_update, :_ns] #, :_id
  # 
  # def visible_attributes
  #   symbolized_instance_variables - InvisibleAttributesNames
  # end
  # 
end
