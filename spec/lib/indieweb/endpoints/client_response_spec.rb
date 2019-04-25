describe IndieWeb::Endpoints::Client, '#response' do
  let(:url) { 'https://example.com' }

  let(:client) { described_class.new(url) }
  let(:request) { stub_request(:get, url) }

  context 'when rescuing an HTTP::ConnectionError' do
    before do
      request.to_raise(HTTP::ConnectionError)
    end

    it 'raises a ConnectionError' do
      expect { client.response }.to raise_error(IndieWeb::Endpoints::ConnectionError)
    end
  end

  context 'when rescuing an HTTP::TimeoutError' do
    before do
      request.to_raise(HTTP::TimeoutError)
    end

    it 'raises a TimeoutError' do
      expect { client.response }.to raise_error(IndieWeb::Endpoints::TimeoutError)
    end
  end

  context 'when rescuing an HTTP::Redirector::TooManyRedirectsError' do
    before do
      request.to_raise(HTTP::Redirector::TooManyRedirectsError)
    end

    it 'raises a TooManyRedirectsError' do
      expect { client.response }.to raise_error(IndieWeb::Endpoints::TooManyRedirectsError)
    end
  end
end
