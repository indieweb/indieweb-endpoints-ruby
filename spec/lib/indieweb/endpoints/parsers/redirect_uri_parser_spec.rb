describe IndieWeb::Endpoints::Parsers::RedirectUriParser do
  let(:url) { 'https://example.com' }

  let(:endpoint) { 'https://example.com/redirect' }

  let(:endpoints) { [endpoint] }

  let :http_response_headers do
    { 'Content-Type': 'text/html' }
  end

  let(:client) { IndieWeb::Endpoints::Client.new(url) }

  context 'when given a URL that does not advertise any callback URLs' do
    before do
      stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
    end

    it 'returns nil' do
      expect(described_class.new(client.response).results).to be_nil
    end
  end

  context 'when given a URL advertising callback URLs in an HTTP Link header' do
    context 'when the HTTP Link header references a relative URL and the `rel` parameter is unquoted' do
      before do
        stub_request(:get, url).to_return(headers: { 'Link': '</redirect>; rel=redirect_uri' })
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the HTTP Link header references an absolute URL and the `rel` parameter is unquoted' do
      before do
        stub_request(:get, url).to_return(headers: { 'Link': %(<#{endpoint}>; rel=redirect_uri) })
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the HTTP Link header has strange casing' do
      before do
        stub_request(:get, url).to_return(headers: { 'LinK' => %(<#{endpoint}>; rel=redirect_uri) })
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the `rel` parameter is quoted' do
      before do
        stub_request(:get, url).to_return(headers: { 'Link': %(<#{endpoint}>; rel="redirect_uri") })
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the `rel` parameter contains multiple space-separated values' do
      before do
        stub_request(:get, url).to_return(headers: { 'Link': %(<#{endpoint}>; rel="redirect_uri somethingelse") })
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the response includes multiple HTTP Link headers' do
      let(:endpoints) { ['https://example.com/callback', 'https://example.com/redirect'] }

      before do
        stub_request(:get, url).to_return(headers: { 'Link': [%(<#{endpoint}#error>; rel="redirect_uri"), %(</redirect_uri/error>; rel="redirect_uri_error"), %(<#{endpoint}>; rel="redirect_uri"), '</callback>; rel="redirect_uri"'] })
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the HTTP Link header contains multiple comma-separated values' do
      before do
        stub_request(:get, url).to_return(headers: { 'Link': %(</redirect_uri/error>; rel="other", <#{endpoint}>; rel="redirect_uri") })
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the HTTP Link header redirects to a relative URL' do
      let(:url) { 'https://example.com/page' }

      let(:endpoint) { 'https://example.com/page/redirect_uri/endpoint' }

      before do
        stub_request(:get, url).to_return(headers: { 'Location': 'page/redirect_uri' }, status: 302)

        stub_request(:get, "#{url}/redirect_uri").to_return(headers: http_response_headers.merge('Link': "<#{endpoint}>; rel=redirect_uri"))
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end
  end

  context 'when given a URL advertising callback URLs in an HTML `link` element' do
    context 'when the `link` element references a relative URL' do
      let(:url) { 'https://example.com/link_element_relative_url' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the `link` element references an absolute URL' do
      let(:url) { 'https://example.com/link_element_absolute_url' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the `rel` attribute contains multiple space-separated values' do
      let(:url) { 'https://example.com/link_element_multiple_rel_values' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the `rel` attribute contains similar values' do
      let(:url) { 'https://example.com/link_element_exact_match' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the HTML contains an endpoint in an HTML comment' do
      let(:url) { 'https://example.com/link_element_html_comment' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the `href` attribute is empty' do
      let(:url) { 'https://example.com/link_element_empty_href' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq([url])
      end
    end

    context 'when the `href` attribute does not exist' do
      let(:url) { 'https://example.com/link_element_no_href' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the `link` element references a URL with a query string' do
      let(:url) { 'https://example.com/link_element_query_string' }

      let(:endpoints) { ['https://example.com/redirect?query=yes'] }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the `link` element references a URL relative to the page' do
      let(:url) { 'https://example.com/link_element/relative_path' }

      let(:endpoints) { ['https://example.com/link_element/relative_path/redirect'] }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end

    context 'when the `link` element references an invalid URL' do
      let(:url) { 'https://example.com/link_element/invalid_href' }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'raises an InvalidURIError' do
        expect { described_class.new(client.response).results }.to raise_error(IndieWeb::Endpoints::InvalidURIError)
      end
    end

    context 'when the `link` element references a URL with a fragment' do
      let(:url) { 'https://example.com/link_element_fragment' }

      let(:endpoints) { ['https://example.com/redirect_uri'] }

      before do
        stub_request(:get, url).to_return(headers: http_response_headers, body: read_fixture(url))
      end

      it 'returns an Array' do
        expect(described_class.new(client.response).results).to eq(endpoints)
      end
    end
  end

  context 'when given a URL advertising multiple callback URLs' do
    let(:url) { 'https://example.com/multiple_endpoints' }

    let(:endpoints) { ['https://example.com/callback', 'https://example.com/redirect'] }

    before do
      stub_request(:get, url).to_return(headers: http_response_headers.merge('Link': %(</redirect>; rel="redirect_uri")), body: read_fixture(url))
    end

    it 'returns an Array' do
      expect(described_class.new(client.response).results).to eq(endpoints)
    end
  end
end
