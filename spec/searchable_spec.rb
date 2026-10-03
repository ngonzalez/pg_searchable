RSpec.describe Searchable do
  let!(:notebook) { Collection.create!(name: "Brown Notebook") }
  let!(:cafe) { Collection.create!(name: "Café de Flore") }
  let!(:poems) { Collection.create!(name: "Poems").tap { |collection| collection.books.create!(name: "Autumn Leaves") } }

  it "finds records by full-text search, with stemming" do
    expect(Collection.search("notebooks")).to eq([notebook])
  end

  it "finds records by substring" do
    expect(Collection.search("otebo")).to eq([notebook])
  end

  it "finds records matching several words" do
    expect(Collection.search("brown note")).to eq([notebook])
  end

  it "finds records by a field of a joined table" do
    expect(Collection.search("autumn")).to eq([poems])
  end

  it "returns each record once when several joined records match" do
    poems.books.create!(name: "Autumn Rain")
    expect(Collection.search("autumn").to_a).to eq([poems])
  end

  it "finds records with accented characters" do
    expect(Collection.search("café")).to eq([cafe])
  end

  it "uses the French configuration for the French locale" do
    I18n.with_locale(:fr) { expect(Collection.search("cafés")).to eq([cafe]) }
  end

  it "falls back to the simple configuration for other locales" do
    I18n.with_locale(:de) { expect(Collection.search("poems")).to eq([poems]) }
  end

  it "returns no records for blank keywords" do
    expect(Collection.search("")).to be_empty
    expect(Collection.search("  ")).to be_empty
    expect(Collection.search("'!?")).to be_empty
  end

  it "is safe with quotes and SQL in keywords" do
    expect(Collection.search("'; DROP TABLE collections; --")).to be_empty
    expect(Collection.count).to eq(3)
  end

  describe "relation" do
    it "returns a relation" do
      expect(Collection.search("brown")).to be_a(ActiveRecord::Relation)
    end

    it "can be ordered, including by expressions" do
      notebook.update_column(:created_at, 1.day.from_now)

      expect(Collection.search("o").order(name: :desc).to_a).to eq([poems, cafe, notebook])
      expect(Collection.search("o").order(Arel.sql("collections.created_at::timestamp DESC")).to_a).to eq([notebook, poems, cafe])
    end

    it "can be chained to a scope" do
      expect(Collection.where.not(id: notebook.id).search("o")).to contain_exactly(cafe, poems)
    end

    it "can be combined with or" do
      expect(Collection.where(name: "Poems").or(Collection.search("brown"))).to contain_exactly(notebook, poems)
    end
  end

  describe "single table inheritance" do
    let!(:note) { Note.create!(name: "Meeting notes") }

    it "searches subclasses with the searchable fields of their parent" do
      expect(Note.search("meeting")).to eq([note])
      expect(Item.search("meeting")).to eq([note])
    end
  end
end
