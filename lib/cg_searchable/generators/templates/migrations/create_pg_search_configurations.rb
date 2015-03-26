class CreatePgSearchConfigurations < ActiveRecord::Migration
  def change

    ActiveRecord::Base.connection.execute("CREATE EXTENSION IF NOT EXISTS unaccent;")

    I18n.available_locales.each do |locale|
      ActiveRecord::Base.connection.execute("DROP TEXT SEARCH CONFIGURATION IF EXISTS search_cfg_#{locale}")
      ActiveRecord::Base.connection.execute("CREATE TEXT SEARCH CONFIGURATION search_cfg_#{locale} (parser=default);")
      ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION search_cfg_#{locale} ADD MAPPING FOR version WITH simple;")
      ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION search_cfg_#{locale} ADD MAPPING FOR asciiword WITH french_stem;")
      ActiveRecord::Base.connection.execute("DROP TEXT SEARCH DICTIONARY IF EXISTS syn_dictionary_#{locale}")
      ActiveRecord::Base.connection.execute("CREATE TEXT SEARCH DICTIONARY syn_dictionary_#{locale} (TEMPLATE = synonym, SYNONYMS = synonym_sample);")
      ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION search_cfg_#{locale} ALTER MAPPING FOR asciiword WITH syn_dictionary_#{locale}, french_stem;")
    end

  end
end