require 'neo4j'

neo4j_base_path = if Rails.env.development?
  File.join(Rails.root, 'tmp')
elsif Rails.env.production?
  capistrano_shared_dir = File.expand_path(File.join(Rails.root, "../../shared"))

  if File.directory?(capistrano_shared_dir) # deployed via capistrano?
    capistrano_shared_dir
  else
    databases_path = File.join(Rails.root, 'databases')
    Dir.mkdir(databases_path) unless File.directory?(databases_path)
    databases_path
  end
end

if [Rails.env.testing?, Rails.env.development?].any?
  Lucene::Config[:store_on_file] = true
  Lucene::Config[:storage_path] = File.join(neo4j_base_path, 'lucene')
  Neo4j::Config[:storage_path] = File.join(neo4j_base_path, 'neo4j')

  puts "storing neo4j's lucene index in #{Lucene::Config[:storage_path]}"
  puts "storing neo4j's database in #{Neo4j::Config[:storage_path]}"
end