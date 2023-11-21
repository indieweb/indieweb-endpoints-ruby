# indieweb-endpoints-ruby

**A Ruby gem for discovering a URL's [IndieAuth](https://indieweb.org/IndieAuth), [Micropub](https://indieweb.org/Micropub), [Microsub](https://indieweb.org/Microsub), and [Webmention](https://indieweb.org/Webmention) endpoints.**

[![Gem](https://img.shields.io/gem/v/indieweb-endpoints.svg?logo=rubygems&style=for-the-badge)](https://rubygems.org/gems/indieweb-endpoints)
[![Downloads](https://img.shields.io/gem/dt/indieweb-endpoints.svg?logo=rubygems&style=for-the-badge)](https://rubygems.org/gems/indieweb-endpoints)
[![Build](https://img.shields.io/github/actions/workflow/status/indieweb/indieweb-endpoints-ruby/ci.yml?branch=main&logo=github&style=for-the-badge)](https://github.com/indieweb/indieweb-endpoints-ruby/actions/workflows/ci.yml)

## Key Features

- Compliant with [Section 4.1](https://www.w3.org/TR/indieauth/#discovery-by-clients) and [Section 4.2.2](https://www.w3.org/TR/indieauth/#redirect-url) of [the W3C's IndieAuth Working Group Note](https://www.w3.org/TR/indieauth/), [Section 5.3](https://www.w3.org/TR/micropub/#endpoint-discovery) of [the W3C's Micropub Recommendation](https://www.w3.org/TR/micropub/), and [Section 3.1.2](https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint) of [the W3C's Webmention Recommendation](https://www.w3.org/TR/webmention/).
- Passes all Endpoint Discovery tests on [webmention.rocks](https://webmention.rocks).
- Supports Ruby 2.7 and newer.

## Getting Started

Before installing and using indieweb-endpoints-ruby, you'll want to have [Ruby](https://www.ruby-lang.org) 2.7 (or newer) installed. Using a Ruby version managment tool like [rbenv](https://github.com/rbenv/rbenv), [chruby](https://github.com/postmodern/chruby), or [rvm](https://github.com/rvm/rvm) is recommended.

indieweb-endpoints-ruby is developed using Ruby 2.7.8 and is tested against additional Ruby versions using [GitHub Actions](https://github.com/indieweb/indieweb-endpoints-ruby/actions).

## Installation

Add indieweb-endpoints-ruby to your project's `Gemfile` and run `bundle install`:

```ruby
source "https://rubygems.org"

gem "indieweb-endpoints"
```

## Usage

### Basic Usage

With indieweb-endpoints-ruby added to your project's `Gemfile` and installed, you may discover a URL's IndieWeb-relevant endpoints by doing:

```ruby
require "indieweb/endpoints"

IndieWeb::Endpoints.get("https://aaronparecki.com")
#=> { authorization_endpoint: "https://aaronparecki.com/auth", "indieauth-metadata": "https://aaronparecki.com/.well-known/oauth-authorization-server", micropub: "https://aaronparecki.com/micropub", microsub: "https://aperture.p3k.io/microsub/1", redirect_uri: nil, token_endpoint: "https://aaronparecki.com/auth/token", webmention: "https://webmention.io/aaronpk/webmention" }
```

This example will search `https://aaronparecki.com` for valid IndieAuth, Micropub, and Webmention endpoints and return a `Hash` of results. Each key in the returned `Hash` will have a value of either a `String` representing a URL or `nil`. The `redirect_uri` key's value will be either an `Array` or `nil` since a given URL may register multiple callback URLs.

### Advanced Usage

Should the need arise, you may work with the `IndieWeb::Endpoints::Client` class:

```ruby
require "indieweb/endpoints"

client = IndieWeb::Endpoints::Client.new("https://aaronparecki.com")
#=> #<IndieWeb::Endpoints::Client uri: "https://aaronparecki.com">

client.response
#=> #<HTTP::Response/1.1 200 OK {…}>

client.endpoints
#=> { authorization_endpoint: "https://aaronparecki.com/auth", micropub: "https://aaronparecki.com/micropub", microsub: "https://aperture.p3k.io/microsub/1", redirect_uri: nil, token_endpoint: "https://aaronparecki.com/auth/token", webmention: "https://webmention.io/aaronpk/webmention" }
```

### Exception Handling

There are several exceptions that may be raised by indieweb-endpoints-ruby's underlying dependencies. These errors are raised as subclasses of `IndieWeb::Endpoints::Error` (which itself is a subclass of `StandardError`).

From [sporkmonger/addressable](https://github.com/sporkmonger/addressable):

- `IndieWeb::Endpoints::InvalidURIError`

From [httprb/http](https://github.com/httprb/http):

- `IndieWeb::Endpoints::HttpError`

From the Ruby Standard Library's [`OpenSSL::SSL::SSLError`](https://ruby-doc.org/stdlib-2.7.8/libdoc/openssl/rdoc/OpenSSL/SSL/SSLError.html):

- `IndieWeb::Endpoints::SSLError`

## Contributing

See [CONTRIBUTING.md](https://github.com/indieweb/indieweb-endpoints-ruby/blob/main/CONTRIBUTING.md) for more on how to contribute to indieweb-endpoints-ruby. Your help is greatly appreciated!

By contributing to and participating in the development of indieweb-endpoints-ruby, you acknowledge that you have read and agree to the [IndieWeb Code of Conduct](https://indieweb.org/code-of-conduct).

## Acknowledgments

indieweb-endpoints-ruby wouldn't exist without IndieAuth, Micropub, and Webmention and the hard work put in by everyone involved in the [IndieWeb](https://indieweb.org) movement. Additionally, the comprehensive Webmention Endpoint Discovery test suite at [webmention.rocks](https://webmention.rocks) was invaluable in the development of this Ruby gem.

indieweb-endpoints-ruby is written and maintained by [Jason Garber](https://sixtwothree.org).

## License

indieweb-endpoints-ruby is freely available under the [MIT License](https://opensource.org/licenses/MIT).
