puts "----------------1"


module DingDealer
  autoload :My, 'ding_dealer/my'
  autoload :Acl, 'ding_dealer/acl'
  autoload :Struct, 'ding_dealer/struct'
  autoload :OpenStruct, 'ding_dealer/open_struct'
  autoload :Rest, 'ding_dealer/rest'
  autoload :Page, 'ding_dealer/page'
  autoload :Neo4j, 'ding_dealer/neo4j'
end




class Object
  def dingsl_accessor(*attributes, &block)
    DingDealer::Struct.new(*attributes, &block)
  end
end

Object.class_eval { include DingDealer::My }

# unless defined?(ActiveRecord)
#   require 'ding_dealer/neo4j/active_record_stubs' 
#   ActiveRecord.require 'active_record/validations'
# end

puts "----------------2"

# DingDealer::Neo4j::Node

# Object.class_eval do
#   # include DingDealer::Neo4j::Node
#   # include DingDealer::Neo4j::Relation
# end

puts "----------------3"

ActionController::Base.class_eval do
  include DingDealer::Page
  include DingDealer::Rest
  include DingDealer::Acl
end

require 'ding_dealer/neo4j/neo_extensions'
