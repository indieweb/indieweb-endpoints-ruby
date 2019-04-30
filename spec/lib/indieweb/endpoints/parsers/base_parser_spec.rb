describe IndieWeb::Endpoints::Parsers::BaseParser do
  context 'when not given an HTTP::Response' do
    it 'raises an ArgumentError' do
      message = 'response must be an HTTP::Response (given NilClass)'

      expect { described_class.new(nil) }.to raise_error(IndieWeb::Endpoints::ArgumentError, message)
    end
  end
end
