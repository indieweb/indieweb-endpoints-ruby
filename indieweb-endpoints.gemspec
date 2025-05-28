# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 2.7"

  spec.name = "indieweb-endpoints"
  spec.version = "10.0.1"
  spec.authors = ["Jason Garber"]
  spec.email = ["jason@sixtwothree.org"]

  spec.summary = "Discover a URL’s IndieAuth, Micropub, Microsub, and Webmention endpoints."
  spec.description = spec.summary
  spec.homepage = "https://github.com/indieweb/indieweb-endpoints-ruby"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*"].reject { |f| File.directory?(f) }
  spec.files += ["LICENSE", "CHANGELOG.md", "CODE_OF_CONDUCT.md", "CONTRIBUTING.md", "README.md"]
  spec.files += ["indieweb-endpoints.gemspec"]

  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/releases/tag/v#{spec.version}",
    "documentation_uri" => "https://rubydoc.info/gems/#{spec.name}/#{spec.version}",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "#{spec.homepage}/tree/v#{spec.version}",
  }

  spec.add_dependency "http", "~> 5.2"
  spec.add_dependency "link-header-parser", "~> 7.0", ">= 7.0.1"
  spec.add_dependency "nokogiri-html-ext", "~> 1.6"
end
