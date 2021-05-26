RSpec.describe IndieWeb::Endpoints::Client do
  context 'when not given a String-like object' do
    it 'raises a NoMethodError' do
      expect { described_class.new(nil) }.to raise_error(NoMethodError)
    end
  end
end
