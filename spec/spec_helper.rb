# frozen_string_literal: true

require 'pry-byebug'

require 'simplecov'
require 'webmock/rspec'

require 'indieweb/endpoints'

require_relative 'support/fixture_helpers'
require_relative 'support/webmention_rocks'

RSpec.configure do |config|
  config.include FixtureHelpers

  config.disable_monkey_patching!
end

WebMock.disable_net_connect!(allow: ['webmention.rocks'])
