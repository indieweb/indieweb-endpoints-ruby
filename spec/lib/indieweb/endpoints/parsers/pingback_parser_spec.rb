describe IndieWeb::Endpoints::Parsers::PingbackParser do
  let(:client) { IndieWeb::Endpoints::Client.new(url) }

  context 'when given a URL that does not advertise a Pingback endpoint' do
    let(:url) { 'https://anyoldurl.com' }

    it 'returns nil' do
      stub_request(:get, url).to_return(status: 200, headers: { content_type: 'text/html' }, body: '<html lang="en"/>')
      expect(described_class.new(client.response).results).to eq(nil)
    end
  end

  context 'when given a URL advertises a Pingback endpoint' do
    let(:url) { 'https://anyoldurl.com' }

    it 'returns the discovered Pingback URL' do
      stub_request(:get, url).to_return(status: 200, headers: { content_type: 'text/html' }, body: %(<html lang="en"><link rel="pingback" href="#{url}/xmlrpc.php"></html>))
      expect(described_class.new(client.response).results).to eq("#{url}/xmlrpc.php")
    end
  end
end
