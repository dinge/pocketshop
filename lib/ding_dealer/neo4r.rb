unless defined?(ActiveRecord)
  require File.dirname(__FILE__) + '/neo4j/active_record_stubs'
end

Object.class_eval do
  include DingDealer::Neo4j::Node
  include DingDealer::Neo4j::Relation
end