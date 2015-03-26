class CreatePgSearchConfigurations < ActiveRecord::Migration
  def change

    ActiveRecord::Base.connection.execute("CREATE EXTENSION IF NOT EXISTS unaccent;")

    # French config
    ActiveRecord::Base.connection.execute("CREATE TEXT SEARCH CONFIGURATION search_cfg_fr (parser=default);")
    ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION search_cfg_fr ADD MAPPING FOR version WITH simple;")
    ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION search_cfg_fr ADD MAPPING FOR asciiword WITH french_stem;")
    ActiveRecord::Base.connection.execute("CREATE TEXT SEARCH DICTIONARY syn_dictionary_fr (TEMPLATE = synonym, SYNONYMS = synonym_sample);")
    ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION search_cfg_fr ALTER MAPPING FOR asciiword WITH syn_dictionary_fr, french_stem;")

    # English config
    ActiveRecord::Base.connection.execute("CREATE TEXT SEARCH CONFIGURATION search_cfg_en (parser=default);")
    ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION search_cfg_en ADD MAPPING FOR version WITH simple;")
    ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION search_cfg_en ADD MAPPING FOR asciiword WITH english_stem;")
    ActiveRecord::Base.connection.execute("CREATE TEXT SEARCH DICTIONARY syn_dictionary_en (TEMPLATE = synonym, SYNONYMS = synonym_sample);")
    ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION search_cfg_en ALTER MAPPING FOR asciiword WITH syn_dictionary_en, english_stem;")

  end
end