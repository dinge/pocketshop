require 'neo4j'
Lucene::Config[:store_on_file] = true
Lucene::Config[:storage_path] = File.join(Rails.root, 'tmp', 'lucene')

# require 'ruby_extensions'

require 'robo_rails/neo4r'
require 'my'

require 'digest/sha1'

Object.class_eval do
  include My
end