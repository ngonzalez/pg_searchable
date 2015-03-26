class CreatePgSearchConfigurations < ActiveRecord::Migration
  def change

    ActiveRecord::Base.connection.execute("CREATE EXTENSION IF NOT EXISTS unaccent;")
    I18n.available_locales.each do |locale|
      ActiveRecord::Base.connection.execute("DROP TEXT SEARCH CONFIGURATION IF EXISTS search_cfg_#{locale}")
      ActiveRecord::Base.connection.execute("CREATE TEXT SEARCH CONFIGURATION search_cfg_#{locale} (parser=default);")
      ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION search_cfg_#{locale} ADD MAPPING FOR version WITH simple;")
      ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION search_cfg_#{locale} ADD MAPPING FOR asciiword WITH #{locale == :fr ? 'french_stem' : 'english_stem'};")
    end

  end
end