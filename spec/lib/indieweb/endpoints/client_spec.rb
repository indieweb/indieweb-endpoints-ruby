# frozen_string_literal: true

RSpec.describe IndieWeb::Endpoints::Client do
  subject(:client) { described_class.new(url) }

  context 'when given invalid arguments' do
    let(:url) { '1:' }

    it 'raises an IndieWeb::Endpoints::InvalidURIError' do
      expect { client }.to raise_error(IndieWeb::Endpoints::InvalidURIError)
    end
  end
end
