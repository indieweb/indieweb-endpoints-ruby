# frozen_string_literal: true

RSpec.describe IndieWeb::Endpoints::Parser, ".matches" do
  subject(:parser) { described_class.new(headers: headers) }

  let(:headers) { ["<1:>; rel=webmention"] }

  it "raises an IndieWeb::Endpoints::InvalidURIError" do
    expect { parser.matches("webmention") }.to raise_error(IndieWeb::Endpoints::InvalidURIError)
  end
end
