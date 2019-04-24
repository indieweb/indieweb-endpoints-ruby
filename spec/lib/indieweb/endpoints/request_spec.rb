describe IndieWeb::Endpoints::Request do
  context 'when not given an Addressable::URI' do
    it 'raises an ArgumentError' do
      message = 'url must be an Addressable::URI (given NilClass)'

      expect { described_class.new(nil) }.to raise_error(IndieWeb::Endpoints::ArgumentError, message)
    end
  end
end
