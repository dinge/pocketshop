class Object
  def dingsl_accessor(*attributes, &block)
    DingDealer::Struct.new(*attributes, &block)
  end
end

Object.class_eval { include DingDealer::My }

unless defined?(ActiveRecord)
  require 'ding_dealer/neo4j/active_record_stubs' 
  ActiveRecord.require 'active_record/validations'
end

Object.class_eval do
  include DingDealer::Neo4j::Node
  include DingDealer::Neo4j::Relation
end

ActionController::Base.class_eval do
  include DingDealer::Rest
  include DingDealer::Acl
end

require 'ding_dealer/neo4j/neo_extensions'