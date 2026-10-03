require "active_record"
require "pg_searchable"

# Connects with DATABASE_URL, or the libpq PG* environment variables
ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || { adapter: "postgresql" })
ActiveRecord::Schema.verbose = false
I18n.available_locales = [:en, :fr, :de]

# Temporary tables only exist for this connection and are dropped when it closes
ActiveRecord::Schema.define do
  create_table :collections, temporary: true do |t|
    t.string :name
    t.timestamps
  end

  create_table :books, temporary: true do |t|
    t.references :collection
    t.string :name
  end

  create_table :items, temporary: true do |t|
    t.string :type
    t.string :name
  end
end

class Book < ActiveRecord::Base
  belongs_to :collection
end

class Collection < ActiveRecord::Base
  has_many :books
  searchable :name, books: [:name]
end

class Item < ActiveRecord::Base
  searchable :name
end

class Note < Item; end

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
