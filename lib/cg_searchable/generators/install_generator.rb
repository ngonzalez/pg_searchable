module CgSearchable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __FILE__)

      def copy_initializer
        template "searchable.rb", "config/initializers/01_searchable.rb"
      end
    end
  end
end