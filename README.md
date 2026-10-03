#### pg_searchable

Search helpers for Ruby on Rails

##### Installation

Add this line to your application's Gemfile:

```ruby
gem "pg_searchable", "0.1.8", github: "ngonzalez/pg_searchable"
```

##### Usage
```ruby
rails g pg_searchable:install
```

```ruby
class Collection < ActiveRecord::Base
  has_many :books
  searchable :name, books: { tag: [:name] }
end
```

```ruby
Collection.search "Example"
```

`search` returns an `ActiveRecord::Relation`, so it can be chained:

```ruby
Collection.where(published: true).search("Example").order(:name)
Collection.where(tag: "example").or(Collection.search("Example"))
```

- Keywords match full-text (stemmed, with the `english` or `french` text search configuration for the `en` and `fr` locales, `simple` otherwise) or as a substring.
- Letters (including accented letters) and digits are kept; blank keywords return no records.
- Records are found even without matching rows in the joined tables.
- Subclasses (STI) search with the fields declared on their parent.

##### Tests

The specs use temporary tables in a PostgreSQL database, set with `DATABASE_URL` or the `PG*` environment variables:

```bash
DATABASE_URL=postgres://localhost/pg_searchable_test bundle exec rspec
```

## Contributing

1. Fork it ( https://github.com/ngonzalez/pg_searchable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
