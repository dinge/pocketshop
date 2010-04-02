class Kos::PocketShop::Shop
  include Neo4j::NodeMixin

  has_n :pointers
  has_n :product_groups
  has_n :products


  # kos.node do
  #
  # end
  #
  # kos.gui do
  #
  # end


  class ShopController


  end

  class ShopPresenter


  end


end