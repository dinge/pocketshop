class Tag
  is_a_neo_node :with_meta_info => true

  property :name, :text
  index :name, :text

  has_one(:creator).from(Local::User, :created_tags)
  has_n(:tagged_concepts).to(Local::Concept).relation(Taggings::Basic)

end
