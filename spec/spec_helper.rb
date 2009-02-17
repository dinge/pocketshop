# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  # config.use_transactional_fixtures = true
  # config.use_instantiated_fixtures  = false
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end


#
# Helper methods for specs
# based from neo4j.rb spec
#

require 'fileutils'
require 'tmpdir'

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
    FileUtils.rm_rf Lucene::Config[:storage_path]
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
