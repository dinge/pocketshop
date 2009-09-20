require 'pp'
require 'fileutils'
require 'tmpdir'


# some example routes needed in some controller tests
ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'index'
  map.resources :beans, :collection => { :full_access_for_test => :get }
  map.resources :dummies, :collection => { :full_access_for_test => :get }
end

Time.zone = "Berlin"

def fixed_datetime
  DateTime.now.change(:year => 2000, :month => 1, :day => 1, :hour => 10, :min => 56, :sec => 12 )
end

def delete_all_nodes_from(*klasses)
  klasses.each{ |klass| klass.all.nodes.each(&:delete) }
end

def restart_transaction
  Neo4j::Transaction.finish; Neo4j::Transaction.new
end


#
# Helper methods for specs
# based on neo4j.rb spec
#

$NEO_LOGGER.level = Logger::ERROR
NEO_STORAGE = Dir::tmpdir + "/neo_storage"
LUCENE_INDEX_LOCATION = Dir::tmpdir + "/lucene"

Lucene::Config[:storage_path] = LUCENE_INDEX_LOCATION
Lucene::Config[:store_on_file] = false
# Neo4j::Config[:storage_path] = NEO_STORAGE

def delete_neo4jdb_files
  FileUtils.rm_rf Neo4j::Config[:storage_path]  # NEO_STORAGE
  FileUtils.rm_rf Lucene::Config[:storage_path] unless Lucene::Config[:storage_path].nil?
end

def reset_config
  # reset configuration
  Lucene::Config.delete_all
  # Lucene::Config[:storage_path] = LUCENE_INDEX_LOCATION
  Lucene::Config[:store_on_file] = false

  Neo4j::Config.delete_all
  Neo4j::Config[:storage_path] = NEO_STORAGE
end

def start_neo4j
  # stop it - just in case
  stop_neo4j
  delete_neo4jdb_files
  reset_config
  # start neo
  Neo4j.event_handler.remove_all  # TODO need a nicer way to test extension - loading and unloading
  Neo4j.load_reindexer
  Neo4j.start
end


def stop_neo4j
  # make sure we finish all transactions
  Neo4j::Transaction.finish if Neo4j::Transaction.running?
  Neo4j.stop
  delete_neo4jdb_files
  reset_config
end

def undefine_class(*clazz_syms)
  clazz_syms.each do |clazz_sym|
    Object.instance_eval do
      begin
        clazz = const_get(clazz_sym)
        Neo4j::Indexer.remove_instance(clazz) if clazz.included_modules.include?(Neo4j::NodeMixin)
        remove_const(clazz_sym)
      end if const_defined?(clazz_sym)
    end
  end
end


def clazz_from_symbol(classname_as_symbol)
  classname_as_symbol.to_s.split("::").inject(Kernel) do |container, name|
    container.const_get(name.to_s)
  end
end