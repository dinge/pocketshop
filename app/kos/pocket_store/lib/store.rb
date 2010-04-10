class Kos::PocketStore::Store
  include Neo4j::NodeMixin

  has_n   :items
  has_n   :groups

  property  :title

  index :title
end