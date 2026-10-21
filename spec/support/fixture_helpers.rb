# frozen_string_literal: true

module FixtureHelpers
  def read_fixture(url)
    file_name = "#{url[8..].gsub(%r{[/.]}, "_")}.html"

    File.read(File.join(Dir.pwd, "spec/support/fixtures/#{file_name}"))
  end
end
