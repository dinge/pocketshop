require 'ding_dealer/neo4r'
require 'my'
require 'digest/sha1'

require 'ding_dealer/struct'
require 'ding_dealer/guid'
require 'ding_dealer/rest'
require 'ding_dealer/acl'

Object.class_eval do
  include My
end
