describe IndieWeb::Endpoints::Client do
  context 'when not given a String' do
    it 'raises an ArgumentError' do
      message = 'url must be a String (given NilClass)'

      expect { described_class.new(nil) }.to raise_error(IndieWeb::Endpoints::ArgumentError, message)
    end
  end

  context 'when given an invalid URL' do
    it 'raises an InvalidURIError' do
      expect { described_class.new('http:') }.to raise_error(IndieWeb::Endpoints::InvalidURIError)
    end
  end

  context 'when given a relative URL' do
    it 'raises an ArgumentError' do
      message = 'url (../foo/bar/biz/baz) must be an absolute URL (e.g. https://example.com)'

      expect { described_class.new('../foo/bar/biz/baz') }.to raise_error(IndieWeb::Endpoints::ArgumentError, message)
    end
  end

  context 'when given a URL with an invalid protocol' do
    it 'raises an ArgumentError' do
      message = 'url (file:///foo/bar/baz) must be an absolute URL (e.g. https://example.com)'

      expect { described_class.new('file:///foo/bar/baz') }.to raise_error(IndieWeb::Endpoints::ArgumentError, message)
    end
  end
end
