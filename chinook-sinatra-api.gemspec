# frozen_string_literal: true

require_relative "lib/chinook_sinatra_api/version"

Gem::Specification.new do |spec|
  spec.name = "chinook_sinatra_api"
  spec.version = ChinookSinatraApi::VERSION
  spec.authors = ["jouk"]
  spec.email = ["jmartinezdiz@outlook.com"]

  spec.summary = "This repository contains an example of JSON API using SQLite and Sinatra with Chinook database"
  spec.description = "This repository contains an example of JSON API using SQLite and Sinatra with Chinook database"
  spec.homepage = "https://github.com/SilviaCTeimas/chinook-sinatra-api-gem"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["chinook_sinatra_api_server"]
  spec.require_paths = ["lib"]

  spec.add_dependency 'sinatra', '~> 4.2'
  spec.add_dependency 'puma', '~> 7.1'
  spec.add_dependency 'rackup', '~> 2.1'
  spec.add_dependency 'sqlite3', '~> 2.9'
  spec.add_development_dependency 'awesome_print', '~> 1.8'
  spec.add_development_dependency 'byebug', '~> 12.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'minitest', '~> 5.16'
  spec.add_development_dependency 'rack-test', '~> 2.2'

end
