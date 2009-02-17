class Tagging
  is_a_neo_relation :meta_info => true

  # include Neo4j::RelationMixin
  
  property :name
end
