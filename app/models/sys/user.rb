class Sys::User
  is_a_neo_node :with_meta_info => true

  property :name, :created_at, :updated_at, :version
  index :name, :created_at, :updated_at, :version


  def self.current
    Sys::User.load(4118)
  end

end
