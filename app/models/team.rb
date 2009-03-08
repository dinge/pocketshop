class Team
  is_a_neo_node do
    options.meta_info = true
    options.validations = true
  end

  property :name
  index :name

  validates_presence_of :name

  has_one(:creator).from(User, :created_teams)
end
