require 'neo4j'

Lucene::Config[:store_on_file] = true
Lucene::Config[:storage_path] = File.join(Rails.root, 'tmp', 'lucene')


# require 'ruby_extensions'

require 'robo_rails/neo4r'