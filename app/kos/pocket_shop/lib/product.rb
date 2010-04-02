class Kos::PocketShop::Product
  include Neo4j::NodeMixin

  has_n :product_groups
  has_n :carts
  has_n :orders

  has_one :provided_product

  # needs :product do
  #   mapping do
  #     name
  #     article_number
  #     price
  #     text
  #   end
  # end



  # kos.io do
  #   listens_for :product
  # ends

  # sources_from(:product) do
  #
  # end

end