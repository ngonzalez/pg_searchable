# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pg_searchable/version'

Gem::Specification.new do |spec|
  spec.name          = "pg_searchable"
  spec.version       = PgSearchable::VERSION
  spec.authors       = ["Nicolas Gonzalez"]
  spec.email         = ["nicolasgonzalez180@gmail.com"]
  spec.summary       = %q{PostgreSQL Full-Text Search}
  spec.description   = %q{PostgreSQL Full-Text Search}
  spec.homepage      = "https://github.com/ngonzalez/pg_searchable"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
