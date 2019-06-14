lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'indieweb/endpoints/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ['>= 2.4', '< 2.7']

  spec.name          = 'indieweb-endpoints'
  spec.version       = IndieWeb::Endpoints::VERSION
  spec.authors       = ['Jason Garber']
  spec.email         = ['jason@sixtwothree.org']

  spec.summary       = 'Discover a URL’s IndieAuth, Micropub, Microsub, and Webmention endpoints.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/indieweb/indieweb-endpoints-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(bin|spec)/}) }

  spec.require_paths = ['lib']

  spec.metadata = {
    'bug_tracker_uri' => "#{spec.homepage}/issues",
    'changelog_uri'   => "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"
  }

  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'reek', '~> 5.4'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.71.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.3'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.33'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
  spec.add_development_dependency 'simplecov-console', '~> 0.5.0'
  spec.add_development_dependency 'webmock', '~> 3.6'

  spec.add_runtime_dependency 'absolutely', '~> 3.0'
  spec.add_runtime_dependency 'addressable', '~> 2.6'
  spec.add_runtime_dependency 'http', '~> 5.0.0.pre'
  spec.add_runtime_dependency 'link-header-parser', '~> 0.1.0'
  spec.add_runtime_dependency 'nokogiri', '~> 1.10'
end
