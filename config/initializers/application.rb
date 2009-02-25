require 'neo4j'
require 'robo_rails/neo4r'
require 'my'
require 'digest/sha1'

# require 'ruby_extensions'
require 'ding_dealer/guid'

Object.class_eval do
  include My
end
