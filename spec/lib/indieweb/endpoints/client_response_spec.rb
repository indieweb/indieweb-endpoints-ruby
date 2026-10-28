# frozen_string_literal: true

RSpec.describe IndieWeb::Endpoints::Client, "#response" do
  subject(:response) { described_class.new(url).response }

  let(:url) { "https://example.com" }

  context "when response has a 4xx-level HTTP status code" do
    it "raises an IndieWeb::Endpoints::HttpError" do
      stub_request(:get, url).to_return(status: 404)

      expect { response }.to raise_error(IndieWeb::Endpoints::HttpError)
    end
  end

  context "when rescuing an Errno::ECONNREFUSE" do
    it "raises an IndieWeb::Endpoints::HttpError" do
      stub_request(:get, url).to_raise(Errno::ECONNREFUSED)

      expect { response }.to raise_error(IndieWeb::Endpoints::HttpError)
    end
  end

  context "when rescuing an OpenSSL::SSL::SSLError" do
    it "raises an IndieWeb::Endpoints::SSLError" do
      stub_request(:get, url).to_raise(OpenSSL::SSL::SSLError)

      expect { response }.to raise_error(IndieWeb::Endpoints::SSLError)
    end
  end
end
