class Concept
  is_a_neo_node do
    db do
      meta_info true
      validations true
      # dynamic_properties true
    end
  end

  property :name, :text
  index :name, :text

  has_one(:creator).from(User, :created_concepts)
  has_n(:tags).from(Tag, :tagged_concepts)

  has_n(:attributes).from(Concept::Value::Base, :shared_concepts)
  has_n(:shared_concepts).to(Concept).relationship(Concept::AttributeRelationship)

  # validates_presence_of :name

  # has_n(:tags).to(Tag).relationship(Tagging)
  # has_n(:basic_tags).relationship(Taggings::Basic)
end
