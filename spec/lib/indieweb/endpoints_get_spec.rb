describe IndieWeb::Endpoints, :get do
  let(:url) { 'https://example.com' }

  let :http_response_headers do
    { 'Content-Type': 'text/html' }
  end

  let(:endpoints) do
    OpenStruct.new(
      authorization_endpoint: nil,
      micropub: nil,
      redirect_uri: nil,
      token_endpoint: nil,
      webmention: nil
    )
  end

  context 'when given a URL that does not advertise a Micropub endpoint' do
    before do
      stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
    end

    it 'returns nil' do
      expect(described_class.get(url)).to eq(endpoints)
    end
  end
end
