# Changelog

## 0.6.0 / 2019-06-15

- Updates Parser-related classes to resolve [#2](https://github.com/indieweb/indieweb-endpoints-ruby/issues/2).

## 0.5.0 / 2019-05-09

- Add support for Microsub endpoint discovery ([5e81d9f](https://github.com/indieweb/indieweb-endpoints-ruby/commit/5e81d9f)).
- Refactor parsers to ignore URLs with fragments ([797b376](https://github.com/indieweb/indieweb-endpoints-ruby/commit/797b376)).
- Rescue `NoMethodError` (for `nil`) and `TypeError` (for non-`String`) ([e33522e](https://github.com/indieweb/indieweb-endpoints-ruby/commit/e33522e)).
- Raise `ArgumentError` if url scheme is not `http` or `https` ([8eb1b1a](https://github.com/indieweb/indieweb-endpoints-ruby/commit/8eb1b1a)).
- Shorten up User Agent string ([f9717b4](https://github.com/indieweb/indieweb-endpoints-ruby/commit/f9717b4)).
- Refactor `HTTPRequest` class using specification defaults ([feef2ba](https://github.com/indieweb/indieweb-endpoints-ruby/commit/feef2ba)).

## 0.4.0 / 2019-05-01

- Add `IndieWeb::Endpoints.client` method ([c4d42d0](https://github.com/indieweb/indieweb-endpoints-ruby/commit/c4d42d0)).
- Rename base `Error` class to `IndieWebEndpointsError` ([d6d6f98](https://github.com/indieweb/indieweb-endpoints-ruby/commit/d6d6f98)).
- Add `HttpRequest` class ([7864cbd](https://github.com/indieweb/indieweb-endpoints-ruby/commit/7864cbd)).

## 0.3.0 / 2019-04-30

- `IndieWeb::Endpoints::Client#endpoints` returns an `OpenStruct` instead of a `Hash` ([c209b0b](https://github.com/indieweb/indieweb-endpoints-ruby/commit/c209b0b)).

## 0.2.0 / 2019-04-25

- Subclass exceptions under `IndieWeb::Endpoints::Error` ([667eec7](https://github.com/indieweb/indieweb-endpoints-ruby/commit/667eec7)).
- Refactor parsers and `Registerable` module ([3b96858](https://github.com/indieweb/indieweb-endpoints-ruby/commit/3b96858)).
- Refactor Client#response method ([c36fda3](https://github.com/indieweb/indieweb-endpoints-ruby/commit/c36fda3)).

## 0.1.0 / 2019-04-24

- Initial release!
