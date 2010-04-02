class Kos::PocketShop::Account
  include Neo4j::NodeMixin 

  has_one :setup
  has_n   :shops

end