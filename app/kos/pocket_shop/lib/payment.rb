class Kos::PocketShop::Payment
  include Neo4j::NodeMixin

  has_one :order
  has_one :customer

end