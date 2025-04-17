# frozen_string_literal: true

require_relative "lib/indieweb/endpoints/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 3.0"

  spec.name = "indieweb-endpoints"
  spec.version = IndieWeb::Endpoints::VERSION
  spec.authors = ["Jason Garber"]
  spec.email = ["jason@sixtwothree.org"]

  spec.summary = "Discover a URL’s IndieAuth, Micropub, Microsub, and Webmention endpoints."
  spec.description = spec.summary
  spec.homepage = "https://github.com/indieweb/indieweb-endpoints-ruby"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*"].reject { |f| File.directory?(f) }
  spec.files += ['LICENSE', 'CHANGELOG.md', 'CODE_OF_CONDUCT.md', 'CONTRIBUTING.md', 'README.md']
  spec.files += ['indieweb-endpoints.gemspec']

  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/releases/tag/v#{spec.version}",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "#{spec.homepage}/tree/v#{spec.version}",
  }

  spec.add_runtime_dependency "http", "~> 5.2"
  spec.add_runtime_dependency "link-header-parser", "~> 5.1"
  spec.add_runtime_dependency "nokogiri", ">= 1.16"
end
