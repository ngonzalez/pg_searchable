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
```

Note: Migration will fail if PostgreSQL Search Configurations already
exist with these names: search_cfg_en, search_cfg_en

You can check if it already exists:
```
\dF search_cfg_*
List of text search configurations
-[ RECORD 1 ]--------------
Schema      | public
Name        | search_cfg_en
Description |
-[ RECORD 2 ]--------------
Schema      | public
Name        | search_cfg_fr
Description |
```

## Contributing

1. Fork it ( https://github.com/ngonzalez/cg_searchable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
