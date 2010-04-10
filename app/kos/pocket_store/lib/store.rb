class Kos::PocketStore::Store
  include Neo4j::NodeMixin


  has_n(:items).to(parent::Item)
  has_n(:groups).to(parent::Group)

end