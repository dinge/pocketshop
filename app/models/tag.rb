class Tag
  is_a_neo_node do
    db.meta_info = true
    db.validations = true
  end

  property :name, :text
  index :name, :text

  has_one(:creator).from(User, :created_tags)
  has_n(:tagged_concepts).to(Concept).relation(Taggings::Basic)

  validates_presence_of  :name
end
