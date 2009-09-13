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

  has_n(:units).from(Concept::Unit, :concepts)

  validates_presence_of :name



  # has_n(:tags).to(Tag).relationship(Tagging)

  # has_n(:basic_tags).relationship(Taggings::Basic)


  # collection_name :concepts
  # fields :name, :text, :created_at, :updated_at, :version
  # has_many :units, :class_name => 'Unit'
  # # has_many :embedded_concepts, :class_name => 'Concept'
end
