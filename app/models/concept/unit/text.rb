class Concept::Unit::Text
  is_a_neo_node do
    db do
      meta_info true
      validations true
    end
    defaults do
      minimal_length 1
      maximal_length 1000
      required false
    end
  end

  property :name, :required
  property :minimal_length, :maximal_length
  index :name

  validates_presence_of :name

  # has_one(:creator).from(User, :created_concept_units)
  # has_one(:concept).to(Concept)

end
