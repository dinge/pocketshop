class Kos::PocketShop::ProductGroup
  include Neo4j::NodeMixin

  has_n :products


  # sources_from(:product) do
  #
  # end

end