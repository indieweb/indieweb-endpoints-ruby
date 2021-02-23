require_relative 'lib/indieweb/endpoints/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5', '< 2.8')

  spec.name          = 'indieweb-endpoints'
  spec.version       = IndieWeb::Endpoints::VERSION
  spec.authors       = ['Jason Garber']
  spec.email         = ['jason@sixtwothree.org']

  spec.summary       = 'Discover a URL’s IndieAuth, Micropub, Microsub, and Webmention endpoints.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/indieweb/indieweb-endpoints-ruby'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', '*.md', '*.gemspec'].reject { |f| File.directory?(f) }

  spec.require_paths = ['lib']

  spec.metadata['bug_tracker_uri'] = "#{spec.homepage}/issues"
  spec.metadata['changelog_uri']   = "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"

  spec.add_runtime_dependency 'absolutely', '~> 5.0'
  spec.add_runtime_dependency 'addressable', '~> 2.7'
  spec.add_runtime_dependency 'http', '~> 4.4'
  spec.add_runtime_dependency 'link-header-parser', '~> 2.1'
  spec.add_runtime_dependency 'nokogiri', '~> 1.11'
end
