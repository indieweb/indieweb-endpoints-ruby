# frozen_string_literal: true

RSpec.describe "webmention.rocks Endpoint Discovery tests" do
  WebmentionRocks::ENDPOINT_DISCOVERY_TESTS.each_pair do |url, regexp|
    describe url do
      subject(:webmention_endpoint) { IndieWeb::Endpoints.get(url)[:webmention] }

      it { is_expected.to match(Regexp.new(regexp)) }
    end
  end
end
