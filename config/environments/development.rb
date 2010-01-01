# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# config.threadsafe!


# setting up neo4j database location
neo4j_base_path = File.join(Rails.root, 'tmp')
Lucene::Config[:store_on_file]  = true
Lucene::Config[:storage_path]   = File.join(neo4j_base_path, 'lucene')
Neo4j::Config[:storage_path]    = File.join(neo4j_base_path, 'neo4j')

puts "storing neo4j's lucene index in #{Lucene::Config[:storage_path]}"
puts "storing neo4j's database in #{Neo4j::Config[:storage_path]}"

