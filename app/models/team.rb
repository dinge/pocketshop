class Team
  is_a_neo_node do
    db do
      meta_info true
      validations true
    end
  end

  property :name
  index :name

  validates_presence_of :name

  has_one(:creator).from(User, :created_teams)
end
