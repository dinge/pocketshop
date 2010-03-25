puts "----------------1"

module DingDealer
end


require 'ding_dealer/my'
require 'ding_dealer/acl'
require 'ding_dealer/struct'
require 'open_struct'


# require 'ding_dealer/neo4j'


puts "----------------2"

# 
# module DingDealer
#   # autoload :My, 'ding_dealer/my'
#   # autoload :Acl, 'ding_dealer/acl'
#   # autoload :Struct, 'ding_dealer/struct'
#   # autoload :OpenStruct, 'ding_dealer/open_struct'
#   # autoload :Rest, 'ding_dealer/rest'
#   # autoload :Page, 'ding_dealer/page'
#   # autoload :Neo4j, 'ding_dealer/neo4j'
# end
# 
# # require 'ding_dealer/my'
# # require 'ding_dealer/acl'
# require 'ding_dealer/struct'
# require 'ding_dealer/open_struct'
# # require 'ding_dealer/rest'
# # require 'ding_dealer/page'
# require 'ding_dealer/neo4j'
# 
# 
# class Object
#   def dingsl_accessor(*attributes, &block)
#     DingDealer::Struct.new(*attributes, &block)
#   end
# end
# 
# # Object.class_eval { include DingDealer::My }
# 
# # unless defined?(ActiveRecord)
# #   require 'ding_dealer/neo4j/active_record_stubs' 
# #   ActiveRecord.require 'active_record/validations'
# # end
# # DingDealer::Neo4j::Node
# puts "----------------2"
# skk
# 
# Object.class_eval do
#   include DingDealer::Neo4j::Node
#   include DingDealer::Neo4j::Relation
# end
# 
# 
# 
# 
# puts "----------------3"
# 
# # ActionController::Base.class_eval do
# #   include DingDealer::Page
# #   include DingDealer::Rest
# #   include DingDealer::Acl
# # end
# 
# require 'ding_dealer/neo4j/neo_extensions'
