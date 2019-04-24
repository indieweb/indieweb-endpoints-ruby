module FixtureHelpers
  def read_fixture(url)
    file_name = "#{url.gsub(%r{^https?://}, '').gsub(%r{[/.]}, '_')}.html"

    File.read(File.join(Dir.pwd, 'spec', 'support', 'fixtures', file_name))
  end
end
