RSpec.describe IndieWeb::Endpoints::Client, '#response' do
  let(:url) { 'https://example.com' }

  let(:client) { described_class.new(url) }
  let(:request) { stub_request(:get, url) }

  context 'when rescuing an HTTP::ConnectionError' do
    before do
      request.to_raise(HTTP::ConnectionError)
    end

    it 'raises an HttpError' do
      expect { client.response }.to raise_error(IndieWeb::Endpoints::HttpError)
    end
  end

  context 'when rescuing an HTTP::TimeoutError' do
    before do
      request.to_raise(HTTP::TimeoutError)
    end

    it 'raises an HttpError' do
      expect { client.response }.to raise_error(IndieWeb::Endpoints::HttpError)
    end
  end

  context 'when rescuing an HTTP::Redirector::TooManyRedirectsError' do
    before do
      request.to_raise(HTTP::Redirector::TooManyRedirectsError)
    end

    it 'raises an HttpError' do
      expect { client.response }.to raise_error(IndieWeb::Endpoints::HttpError)
    end
  end

  context 'when given an invalid URL' do
    let(:url) { 'http:' }

    it 'raises an InvalidURIError' do
      expect { client.response }.to raise_error(IndieWeb::Endpoints::InvalidURIError)
    end
  end

  context 'when given a relative URL' do
    let(:url) { '../foo/bar/biz/baz' }

    it 'raises an HttpError' do
      message = 'unknown scheme: '

      expect { client.response }.to raise_error(IndieWeb::Endpoints::HttpError, message)
    end
  end

  context 'when given a URL with an invalid protocol' do
    let(:url) { 'file:///foo/bar/baz' }

    it 'raises an HttpError' do
      message = 'unknown scheme: file'

      expect { client.response }.to raise_error(IndieWeb::Endpoints::HttpError, message)
    end
  end
end
