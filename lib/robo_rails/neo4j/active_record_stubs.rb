unless defined?(ActiveRecord)
  module ActiveRecord
    class Migrator; end
    class ActiveRecordError < StandardError; end

    class Base
      # mocking away some methods normally needed by ActiveRecord
      cattr_accessor :include_root_in_json
      cattr_accessor :store_full_sti_class
      cattr_accessor :instantiate_observers
      cattr_accessor :configurations

      # needed for reload! in script/console
      cattr_accessor :reset_subclasses
      def self.clear_reloadable_connections!; end

      # needed in script/server
      def self.connected?; end
      def self.clear_active_connections!; end
    end
  end

  require 'active_record/validations'
end
