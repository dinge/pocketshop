class Sys::User
  is_a_neo_node :with_meta_info => true

  property :name
  index :name

  property :last_action_at, :type => DateTime

  def self.current
    Sys::User.load(4118)
  end

end
