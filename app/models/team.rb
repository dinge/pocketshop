class Team
  is_a_neo_node do
    options.meta_info = true
    options.validations = true
  end

  property :name
  index :name
end
