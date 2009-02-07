Object.class_eval do
  include RoboRails::Neo4j::Node
  include RoboRails::Neo4j::Relation
  #include RoboRails::Neo4j::DynamicContainer
end