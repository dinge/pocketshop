class Thing
  is_a_neo_node do
    options.meta_info = true
    options.dynamic_properties = true
    options.validations = true
  end

  property :name, :text
  index :name, :text

  validates_presence_of  :name

  has_one(:creator).from(Local::User, :created_things)






  # has_n(:basic_tags).from(Tag)

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
