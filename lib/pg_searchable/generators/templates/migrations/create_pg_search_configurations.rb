class CreatePgSearchConfigurations < ActiveRecord::Migration[6.0]
  def change
    ActiveRecord::Base.connection.execute("CREATE EXTENSION IF NOT EXISTS unaccent;")
    [{ en: "english_stem"}, { fr: "french_stem" }].each do |hash|
      hash.each do |locale, stemmer|
        ActiveRecord::Base.connection.execute("DROP TEXT SEARCH CONFIGURATION IF EXISTS #{locale}")
        ActiveRecord::Base.connection.execute("CREATE TEXT SEARCH CONFIGURATION #{locale} (parser=default);")
        ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION #{locale} ADD MAPPING FOR version WITH simple;")
        ActiveRecord::Base.connection.execute("ALTER TEXT SEARCH CONFIGURATION #{locale} ADD MAPPING FOR asciiword WITH #{stemmer};")
      end
    end
  end
end
