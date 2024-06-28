#### pg_searchable

Integrate PostgreSQL Full Text Search to Rails Applications

##### Installation

Add this line to your application's Gemfile:

```ruby
gem 'pg_searchable', github: 'ngonzalez/pg_searchable'
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

## Contributing

1. Fork it ( https://github.com/ngonzalez/pg_searchable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
