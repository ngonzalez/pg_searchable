module CgSearchable
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      include Rails::Generators::Migration

      def copy_migrations
        migration_template "migrations/create_pg_search_configurations.rb", "db/migrate/create_pg_search_configurations.rb"
      end

      def self.next_migration_number path
        Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
      end

    end
  end
end