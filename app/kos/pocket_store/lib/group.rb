class Kos::PocketStore::Group
  include Neo4j::NodeMixin

  property :title
  property :description

end