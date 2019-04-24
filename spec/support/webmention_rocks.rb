module WebmentionRocks
  ENDPOINT_DISCOVERY_TESTS = [
    ['https://webmention.rocks/test/1',       %r{^https://webmention.rocks/test/1/webmention$}],
    ['https://webmention.rocks/test/2',       %r{^https://webmention.rocks/test/2/webmention$}],
    ['https://webmention.rocks/test/3',       %r{^https://webmention.rocks/test/3/webmention$}],
    ['https://webmention.rocks/test/4',       %r{^https://webmention.rocks/test/4/webmention$}],
    ['https://webmention.rocks/test/5',       %r{^https://webmention.rocks/test/5/webmention$}],
    ['https://webmention.rocks/test/6',       %r{^https://webmention.rocks/test/6/webmention$}],
    ['https://webmention.rocks/test/7',       %r{^https://webmention.rocks/test/7/webmention$}],
    ['https://webmention.rocks/test/8',       %r{^https://webmention.rocks/test/8/webmention$}],
    ['https://webmention.rocks/test/9',       %r{^https://webmention.rocks/test/9/webmention$}],
    ['https://webmention.rocks/test/10',      %r{^https://webmention.rocks/test/10/webmention$}],
    ['https://webmention.rocks/test/11',      %r{^https://webmention.rocks/test/11/webmention$}],
    ['https://webmention.rocks/test/12',      %r{^https://webmention.rocks/test/12/webmention$}],
    ['https://webmention.rocks/test/13',      %r{^https://webmention.rocks/test/13/webmention$}],
    ['https://webmention.rocks/test/14',      %r{^https://webmention.rocks/test/14/webmention$}],
    ['https://webmention.rocks/test/15',      %r{^https://webmention.rocks/test/15$}],
    ['https://webmention.rocks/test/16',      %r{^https://webmention.rocks/test/16/webmention$}],
    ['https://webmention.rocks/test/17',      %r{^https://webmention.rocks/test/17/webmention$}],
    ['https://webmention.rocks/test/18',      %r{^https://webmention.rocks/test/18/webmention$}],
    ['https://webmention.rocks/test/19',      %r{^https://webmention.rocks/test/19/webmention$}],
    ['https://webmention.rocks/test/20',      %r{^https://webmention.rocks/test/20/webmention$}],
    ['https://webmention.rocks/test/21',      %r{^https://webmention.rocks/test/21/webmention\?query=yes$}],
    ['https://webmention.rocks/test/22',      %r{^https://webmention.rocks/test/22/webmention$}],
    ['https://webmention.rocks/test/23/page', %r{^https://webmention.rocks/test/23/page/webmention-endpoint/.*$}]
  ].freeze
end
