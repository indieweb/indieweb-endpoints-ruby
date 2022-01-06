# frozen_string_literal: true

require 'simplecov'
require 'webmock/rspec'

require 'indieweb/endpoints'

Dir.glob(File.join(Dir.pwd, 'spec', 'support', '**', '*.rb')).sort.each { |f| require f }

RSpec.configure do |config|
  config.include FixtureHelpers

  config.disable_monkey_patching!
end

WebMock.disable_net_connect!(allow: ['example.com', 'webmention.rocks'])
