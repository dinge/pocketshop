class Kos::PocketShop::Order
  include Neo4j::NodeMixin 

  has_n   :products
  has_one :customer
  has_one :cart
end