# frozen_string_literal: true

RSpec.describe IndieWeb::Endpoints::Client, '#endpoints' do
  # TODO: Rework these specs to use WebMock: https://github.com/bblimke/webmock
  context 'when running the webmention.rocks Endpoint Discovery tests' do
    WebmentionRocks::ENDPOINT_DISCOVERY_TESTS.each do |url, regexp|
      describe url do
        subject { described_class.new(url).endpoints[:webmention] }

        it { is_expected.to match(regexp) }
      end
    end
  end
end
