describe IndieWeb::Endpoints::Parsers::WebmentionParser do
  let(:client) { IndieWeb::Endpoints::Client.new(url) }

  context 'when given a URL that does not advertise a Webmention endpoint' do
    let(:url) { 'https://example.com' }

    it 'returns nil' do
      expect(described_class.new(client.response).results).to eq(nil)
    end
  end

  context 'when given a URL advertising its Webmention endpoint in an HTTP Link header' do
    let(:url) { 'https://webmention.rocks/test/1' }

    it 'returns a String' do
      expect(described_class.new(client.response).results).to eq('https://webmention.rocks/test/1/webmention')
    end
  end

  # TODO: Rework these specs to use WebMock: https://github.com/bblimke/webmock
  context 'when running the webmention.rocks Endpoint Discovery tests' do
    WebmentionRocks::ENDPOINT_DISCOVERY_TESTS.each do |url, regexp|
      it 'matches the RegExp' do
        client = IndieWeb::Endpoints::Client.new(url)

        expect(described_class.new(client.response).results).to match(regexp)
      end
    end
  end
end
