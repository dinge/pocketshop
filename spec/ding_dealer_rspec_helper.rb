require 'pp'
require 'fileutils'
require 'tmpdir'


# some example routes needed in some controller tests
ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'index'
  map.resources :beans, :collection => { :full_access_for_test => :get }
  map.resources :dummies, :collection => { :full_access_for_test => :get }
end


def fixed_datetime
  DateTime.now.change(:year => 2000, :month => 1, :day => 1, :hour => 10, :min => 56, :sec => 12 )
end


#
# Helper methods for specs
# based on neo4j.rb spec
#

# suppress all warnings
$NEO_LOGGER.level = Logger::ERROR

NEO_STORAGE = Dir::tmpdir + "/neo_storage"
LUCENE_INDEX_LOCATION = Dir::tmpdir + "/lucene"

def start_neo4j
  Lucene::Config[:storage_path] = LUCENE_INDEX_LOCATION
  Lucene::Config[:store_on_file] = true
  Neo4j::Config[:storage_path] = NEO_STORAGE

  delete_neo4jdb_files
  Neo4j.start
end

def stop_neo4j
  Neo4j.stop
  reset_neo4j
end

def reset_neo4j
  # make sure we finish all transactions
  Neo4j::Transaction.current.finish if Neo4j::Transaction.running?
  # delete all configuration
  Lucene::Config.delete_all
  delete_neo4jdb_files
end

def delete_neo4jdb_files
  FileUtils.rm_rf(Neo4j::Config[:storage_path]) if File.exists?(Neo4j::Config[:storage_path])
  if !Lucene::Config[:storage_path].nil? && File.exists?(Lucene::Config[:storage_path])
    FileUtils.rm_rf(Lucene::Config[:storage_path])
  end
end

def undefine_class(*clazz_syms)
  clazz_syms.each do |clazz_sym|
    Object.instance_eval do
      begin
        remove_const clazz_sym
      end if const_defined? clazz_sym
    end
  end
end
