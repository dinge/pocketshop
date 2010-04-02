class Kos::PocketShop::Cart
  include Neo4j::NodeMixin 

  has_n :products
  has_one :order

  # has_one :customer
end