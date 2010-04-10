class Kos::PocketStore::Item
  include Neo4j::NodeMixin

  has_n(:groups).to(parent::Group)
  has_one :store

  has_one :import_source

  property :title
  property :identifier
  property :description
  property :image_path

  property :price

  index :title

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