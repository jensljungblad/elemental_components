# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "elemental_components/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "elemental_components"
  s.version     = ElementalComponents::VERSION
  s.authors     = ["Jens Ljungblad"]
  s.email       = ["jens.ljungblad@gmail.com"]
  s.homepage    = "https://www.github.com/jensljungblad/elemental_components"
  s.summary     = "Simple view components for Rails 6.1+"
  s.description = "Simple view components for Rails 6.1+"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.required_ruby_version = ">= 3.0.0"

  s.add_dependency "rails", ">= 6.1.0", "< 8.0.0"

  s.add_development_dependency "appraisal"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "sqlite3"
end
