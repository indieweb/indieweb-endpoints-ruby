# frozen_string_literal: true

RSpec.describe IndieWeb::Endpoints::Client, '#inspect' do
  subject { described_class.new('https://example.com').inspect }

  it { is_expected.to match(/^#<#{described_class}:0x[a-f0-9]+ uri: ".*">$/) }
end
