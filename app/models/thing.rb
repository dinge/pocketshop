class Thing
  is_a_neo_node do
    db do
      meta_info true
      validations true
      # dynamic_properties true
    end
    acl.default_visibility true
  end


  property :name, :text
  index :name, :text

  validates_presence_of  :name

  has_one(:creator).from(User, :created_things)


  def visible_for?(user)
    creator == user
  end

  def changeable_for?(user)
    creator == user
  end

  def destroyable_for?(user)
    creator == user
  end

  def self.creatable_for?(user)
    Me.someone?
  end


  # has_n(:basic_tags).from(Tag)
  # collection_name :things
  # fields :name, :text, :created_at, :updated_at, :version, :rating, :tags
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
