# frozen_string_literal: true

RSpec.describe IndieWeb::Endpoints::HTTP, "#fetch" do
  it "raises an IndieWeb::Endpoints::InvalidURIError" do
    expect { described_class.new("1:").fetch }.to raise_error(IndieWeb::Endpoints::InvalidURIError)
  end

  it "raises an IndieWeb::Endpoints::HttpError" do
    http = described_class.new("https://website.example")
    http.instance_variable_set(:@redirects, 21)

    expect { http.fetch }.to raise_error(IndieWeb::Endpoints::HttpError)
  end
end
