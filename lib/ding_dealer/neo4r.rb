unless defined?(ActiveRecord)
  require File.dirname(__FILE__) + '/neo4j/active_record_stubs'
end

Object.class_eval do
  include RoboRails::Neo4j::Node
  include RoboRails::Neo4j::Relation
  #include RoboRails::Neo4j::DynamicContainer
end