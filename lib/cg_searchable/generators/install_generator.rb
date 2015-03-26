include Rails::Generators::Migration

module CgSearchable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_initializer
        template "initializers/searchable.rb", "config/initializers/001_cg_searchable.rb"
      end

      def copy_migrations
        migration_template "migrations/create_pg_search_configurations.rb", "db/migrate/cg_searchable.rb"
      end

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

    end
  end
end