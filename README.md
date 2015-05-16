# cg_searchable

Integrate PostgreSQL Full Text Search to Rails Applications

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cg_searchable', github: 'ngonzalez/cg_searchable'
```

And then execute:

    $ bundle

## Usage

```ruby
rails g cg_searchable:install
rake db:migrate
```

Then add searchable attributes to models:
```ruby
class Item < ActiveRecord::Base

    belongs_to :member
    has_many :localized_items
    has_and_belongs_to_many :tags, join_table :taggings

    searchable :name, localized_items: [:title, :description], taggings: { tag: [:name] }, member: [:name]

end
```

You should now be able to search like this:
```ruby
Item.search "Example"
```

## Contributing

1. Fork it ( https://github.com/ngonzalez/cg_searchable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
