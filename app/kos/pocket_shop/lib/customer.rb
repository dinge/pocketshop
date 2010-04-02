class Kos::PocketShop::Customer
  include Neo4j::NodeMixin 

  has_n :orders
  has_one :user

end