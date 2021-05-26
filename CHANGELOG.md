# Changelog

## 6.0.0 / 2021-05-25

- Refactor parsers (e22e0af)
- Simplify exception handling (65361ee)
- Update http dependency to 5.0 (44f2d23)
- **Breaking change:** Favor Addressable::URI.join over Absolutely (0bc5049)
- Update development Ruby version to 2.5.9 (3439cce)

## 5.0.0 / 2020-11-11

- Update absolutely and link-header-parser dependencies (064696e)

## 4.0.0 / 2020-07-21

- **Breaking change:** Return a Hash of endpoints instead of an OpenStruct (15dc387)
- Update [link-header-parser](https://rubygems.org/gems/link-header-parser) dependency to v2.0.0 (2255e6b)
- **Breaking change:** Update development Ruby version to 2.5.8 and minimum Ruby version to 2.5 (dd5a142)
- Refactor response headers/body parsers into a single class (ee02da3)
- Refactor `IndieWeb::Endpoints::Client` and remove `HttpRequestService` (2732616)
- Add offending url to exception message (#5) (4bf7a54)

## 3.0.0 / 2020-05-14

- Update Absolutely and LinkHeaderParser dependencies (9e0a64a)
- Move development dependencies to `Gemfile` (67067f3)
- Update development Ruby version to 2.4.10 (f5430f9)

## 2.0.0 / 2020-01-25

- Downgrade HTTP gem version constraint to ~> 4.3 (cb63230)

## 1.1.0 / 2020-01-20

- Expand supported Ruby versions to include 2.7 (ae63ed0)
- Update project Ruby version to 2.4.9 (e576ad6)

## 1.0.2 / 2019-08-31

- Update WebMock and Addressable gems (298da63)
- Update development dependencies (5663e3a)

## 1.0.1 / 2019-07-17

- Safely combine, flatten, and compact result set (5f2d9c5)

## 1.0.0 / 2019-07-08

-  Refactor gem code using service objects approach (78511d7 and 9d2fee0)

## 0.7.0 / 2019-07-03

- Update runtime and development dependencies (d99214b and 7692ab3)

## 0.6.0 / 2019-06-15

- Update Parser-related classes to resolve #2

## 0.5.0 / 2019-05-09

- Add support for Microsub endpoint discovery (5e81d9f)
- Refactor parsers to ignore URLs with fragments (797b376)
- Rescue `NoMethodError` (for `nil`) and `TypeError` (for non-`String`) (e33522e)
- Raise `ArgumentError` if url scheme is not `http` or `https` (8eb1b1a)
- Shorten up User Agent string (f9717b4)
- Refactor `HTTPRequest` class using specification defaults (feef2ba)

## 0.4.0 / 2019-05-01

- Add `IndieWeb::Endpoints.client` method (c4d42d0)
- Rename base `Error` class to `IndieWebEndpointsError` (d6d6f98)
- Add `HttpRequest` class (7864cbd)

## 0.3.0 / 2019-04-30

- `IndieWeb::Endpoints::Client#endpoints` returns an `OpenStruct` instead of a `Hash` (c209b0b).

## 0.2.0 / 2019-04-25

- Subclass exceptions under `IndieWeb::Endpoints::Error` (667eec7)
- Refactor parsers and `Registerable` module (3b96858)
- Refactor `Client#response` method (c36fda3)

## 0.1.0 / 2019-04-24

- Initial release!
