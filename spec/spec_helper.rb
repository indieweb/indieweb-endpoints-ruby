$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'
require 'webmock/rspec'

require 'indieweb/endpoints'

Dir.glob(File.join(Dir.pwd, 'spec', 'support', '**', '*.rb')).sort.each { |f| require f }

RSpec.configure do |config|
  config.include FixtureHelpers
end

WebMock.disable_net_connect!(allow: ['example.com', 'webmention.rocks'])
