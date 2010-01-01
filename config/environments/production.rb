# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false



# setting up neo4j database location
capistrano_shared_dir = File.expand_path(File.join(Rails.root, "../../shared"))

neo4j_base_path = if File.directory?(capistrano_shared_dir) # deployed via capistrano?
  capistrano_shared_dir
else
  databases_path = File.join(Rails.root, 'databases')
  Dir.mkdir(databases_path) unless File.directory?(databases_path)
  databases_path
end

# neo4j_base_path = File.join(Rails.root, 'tmp')

Lucene::Config[:store_on_file] = true
Lucene::Config[:storage_path] = File.join(neo4j_base_path, 'lucene')
Neo4j::Config[:storage_path] = File.join(neo4j_base_path, 'neo4j')
puts "storing neo4j's lucene index in #{Lucene::Config[:storage_path]}"
puts "storing neo4j's database in #{Neo4j::Config[:storage_path]}"
