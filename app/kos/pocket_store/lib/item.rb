class Kos::PocketStore::Item
  include Neo4j::NodeMixin

  has_one(:source_item)


  property :title
  property :description
  property :price
  property :image_path



  # property :name
  # property :article_number
  # property :price
  # property :source_id
  #
  # index :name
  # index :article_number
  # index :price
  # index :source_id
  #
  # has_n(:categories).to(parent::ProductCategory)


end