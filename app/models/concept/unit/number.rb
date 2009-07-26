class Concept::Unit::Number
  is_a_neo_node do
    db do
      meta_info true
      validations true
    end
    defaults do
      minimal_value -9999999999
      maximal_value 9999999999
      required false
    end
  end

  property :name, :required
  property :minimal_value, :maximal_value
  index :name

  validates_presence_of :name

  # has_one(:creator).from(User, :created_concept_units)
  # has_one(:concept).to(Concept)

end
