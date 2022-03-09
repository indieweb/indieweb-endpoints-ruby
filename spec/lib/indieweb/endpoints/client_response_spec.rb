# frozen_string_literal: true

RSpec.describe IndieWeb::Endpoints::Client, '#response' do
  subject(:response) { described_class.new(url).response }

  let(:url) { 'https://example.com' }

  context 'when rescuing from an HTTP::Error' do
    it 'raises an IndieWeb::Endpoints::HttpError' do
      stub_request(:get, url).to_raise(HTTP::Error)

      expect { response }.to raise_error(IndieWeb::Endpoints::HttpError)
    end
  end

  context 'when rescuing from an OpenSSL::SSL::SSLError' do
    it 'raises an IndieWeb::Endpoints::SSLError' do
      stub_request(:get, url).to_raise(OpenSSL::SSL::SSLError)

      expect { response }.to raise_error(IndieWeb::Endpoints::SSLError)
    end
  end
end
