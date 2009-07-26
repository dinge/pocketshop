class Concept::Unit
  is_a_neo_node do
    db do
      meta_info true
      validations true
      # dynamic_properties true
    end
  end

  property :name, :text
  index :name, :text

  validates_presence_of :name

  has_one(:creator).from(User, :created_concept_units)
  has_one(:concept).to(Concept)
end
