# frozen_string_literal: true

RSpec.shared_examples "a Hash of endpoints" do
  subject { described_class.get(url) }

  before do
    stub_request(:get, url).to_return(response)
  end

  it { is_expected.to eq(endpoints) }
end

RSpec.describe IndieWeb::Endpoints, ".get" do
  context "when given a URL that publishes no endpoints" do
    it_behaves_like "a Hash of endpoints" do
      let(:url) { "https://example.com" }

      let(:response) do
        {
          headers: { "Content-Type": "text/html" },
          body: read_fixture(url)
        }
      end

      let(:endpoints) do
        {
          authorization_endpoint: nil,
          "indieauth-metadata": nil,
          micropub: nil,
          microsub: nil,
          redirect_uri: nil,
          token_endpoint: nil,
          webmention: nil
        }
      end
    end
  end

  context "when given a URL that publishes endpoints in HTTP headers" do
    let(:url) { "https://example.com" }

    let(:endpoints) do
      {
        authorization_endpoint: "https://example.com/authorization_endpoint",
        "indieauth-metadata": "https://example.com/indieauth-metadata",
        micropub: "https://example.com/micropub",
        microsub: "https://example.com/microsub",
        redirect_uri: ["https://example.com/redirect_uri"],
        token_endpoint: "https://example.com/token_endpoint",
        webmention: "https://example.com/webmention"
      }
    end

    # Similar to https://webmention.rocks/test/1
    context "when the HTTP Link header references a relative URL and the `rel` parameter is unquoted" do
      it_behaves_like "a Hash of endpoints" do
        let(:response) do
          {
            headers: {
              Link: [
                "</authorization_endpoint>; rel=authorization_endpoint",
                "</indieauth-metadata>; rel=indieauth-metadata",
                "</micropub>; rel=micropub",
                "</microsub>; rel=microsub",
                "</redirect_uri>; rel=redirect_uri",
                "</token_endpoint>; rel=token_endpoint",
                "</webmention>; rel=webmention"
              ]
            }
          }
        end
      end
    end

    # Similar to https://webmention.rocks/test/2
    context "when the HTTP Link header references an absolute URL and the `rel` parameter is unquoted" do
      it_behaves_like "a Hash of endpoints" do
        let(:url) { "https://example.com" }

        let(:response) do
          {
            headers: {
              Link: [
                %(<#{url}/authorization_endpoint>; rel=authorization_endpoint),
                %(<#{url}/indieauth-metadata>; rel=indieauth-metadata),
                %(<#{url}/micropub>; rel=micropub),
                %(<#{url}/microsub>; rel=microsub),
                %(<#{url}/redirect_uri>; rel=redirect_uri),
                %(<#{url}/token_endpoint>; rel=token_endpoint),
                %(<#{url}/webmention>; rel=webmention)
              ]
            }
          }
        end
      end
    end

    # Similar to https://webmention.rocks/test/7
    context "when the HTTP Link header has strange casing" do
      it_behaves_like "a Hash of endpoints" do
        let(:url) { "https://example.com" }

        let(:response) do
          {
            headers: {
              "LinK" => [
                %(<#{url}/authorization_endpoint>; rel=authorization_endpoint),
                %(<#{url}/indieauth-metadata>; rel=indieauth-metadata),
                %(<#{url}/micropub>; rel=micropub),
                %(<#{url}/microsub>; rel=microsub),
                %(<#{url}/redirect_uri>; rel=redirect_uri),
                %(<#{url}/token_endpoint>; rel=token_endpoint),
                %(<#{url}/webmention>; rel=webmention)
              ]
            }
          }
        end
      end
    end

    # Similar to https://webmention.rocks/test/8
    context "when the `rel` parameter is quoted" do
      it_behaves_like "a Hash of endpoints" do
        let(:response) do
          {
            headers: {
              Link: [
                %(<#{url}/authorization_endpoint>; rel="authorization_endpoint"),
                %(<#{url}/indieauth-metadata>; rel="indieauth-metadata"),
                %(<#{url}/micropub>; rel="micropub"),
                %(<#{url}/microsub>; rel="microsub"),
                %(<#{url}/redirect_uri>; rel="redirect_uri"),
                %(<#{url}/token_endpoint>; rel="token_endpoint"),
                %(<#{url}/webmention>; rel="webmention")
              ]
            }
          }
        end
      end
    end

    # Similar to https://webmention.rocks/test/10
    context "when the `rel` parameter contains multiple space-separated values" do
      it_behaves_like "a Hash of endpoints" do
        let(:response) do
          {
            headers: {
              Link: [
                %(<#{url}/authorization_endpoint>; rel="authorization_endpoint somethingelse"),
                %(<#{url}/indieauth-metadata>; rel="indieauth-metadata somethingelse"),
                %(<#{url}/micropub>; rel="micropub somethingelse"),
                %(<#{url}/microsub>; rel="microsub somethingelse"),
                %(<#{url}/redirect_uri>; rel="redirect_uri somethingelse"),
                %(<#{url}/token_endpoint>; rel="token_endpoint somethingelse"),
                %(<#{url}/webmention>; rel="webmention somethingelse")
              ]
            }
          }
        end
      end
    end

    # Similar to https://webmention.rocks/test/18
    context "when the response includes multiple HTTP Link headers" do
      it_behaves_like "a Hash of endpoints" do
        let(:response) do
          {
            headers: {
              Link: [
                %(<#{url}/authorization_endpoint#error>; rel="authorization_endpoint"),
                %(</authorization_endpoint/error>; rel="authorization_endpoint_error"),
                %(<#{url}/authorization_endpoint>; rel="authorization_endpoint"),
                '</authorization_endpoint/error>; rel="other"',
                %(<#{url}/redirect_uri>; rel="redirect_uri"),
                '</callback>; rel="redirect_uri"'
              ]
            }
          }
        end

        let(:endpoints) do
          {
            authorization_endpoint: "https://example.com/authorization_endpoint",
            "indieauth-metadata": nil,
            micropub: nil,
            microsub: nil,
            redirect_uri: ["https://example.com/callback", "https://example.com/redirect_uri"],
            token_endpoint: nil,
            webmention: nil
          }
        end
      end
    end

    # Similar to https://webmention.rocks/test/19
    context "when the HTTP Link header contains multiple comma-separated values" do
      it_behaves_like "a Hash of endpoints" do
        let(:response) do
          {
            headers: {
              Link: [
                %(</authorization_endpoint/error>; rel="other", \
                  <#{url}/authorization_endpoint>; rel="authorization_endpoint"),
                %(</indieauth-metadata/error>; rel="other", </indieauth-metadata>; rel="indieauth-metadata"),
                %(</micropub/error>; rel="other", <#{url}/micropub>; rel="micropub"),
                %(</microsub/error>; rel="other", <#{url}/microsub>; rel="microsub"),
                %(</redirect_uri/error>; rel="other", <#{url}/redirect_uri>; rel="redirect_uri"),
                %(</token_endpoint/error>; rel="other", <#{url}/token_endpoint>; rel="token_endpoint"),
                %(</webmention/error>; rel="other", <#{url}/webmention>; rel="webmention")
              ]
            }
          }
        end
      end
    end

    # Similar to https://webmention.rocks/test/23
    context "when the HTTP Link header redirects to a relative URL" do
      it_behaves_like "a Hash of endpoints" do
        let(:response) do
          {
            headers: { Location: "page/authorization_endpoint" },
            status: 302
          }
        end

        let(:endpoints) do
          {
            authorization_endpoint: "https://example.com/page/authorization_endpoint/endpoint",
            "indieauth-metadata": nil,
            micropub: nil,
            microsub: nil,
            redirect_uri: nil,
            token_endpoint: nil,
            webmention: nil
          }
        end

        # Note that this executes after the shared example's before block
        before do
          redirected_url = "https://example.com/page/authorization_endpoint"

          stub_request(:get, redirected_url).to_return(
            headers: {
              "Content-Type": "text/html",
              Link: "<#{redirected_url}/endpoint>; rel=authorization_endpoint"
            }
          )
        end
      end
    end
  end

  context "when given a URL that publishes endpoints in HTML elements" do
    let(:response) do
      {
        headers: { "Content-Type": "text/html" },
        body: read_fixture(url)
      }
    end

    let(:endpoints) do
      {
        authorization_endpoint: "https://example.com/authorization_endpoint",
        "indieauth-metadata": "https://example.com/indieauth-metadata",
        micropub: "https://example.com/micropub",
        microsub: "https://example.com/microsub",
        redirect_uri: ["https://example.com/redirect"],
        token_endpoint: "https://example.com/token_endpoint",
        webmention: nil
      }
    end

    # Similar to https://webmention.rocks/test/3
    context "when the `link` element references a relative URL" do
      it_behaves_like "a Hash of endpoints" do
        let(:url) { "https://example.com/link_element_relative_url" }
      end
    end

    # Similar to https://webmention.rocks/test/4
    context "when the `link` element references an absolute URL" do
      it_behaves_like "a Hash of endpoints" do
        let(:url) { "https://example.com/link_element_absolute_url" }
      end
    end

    # Similar to https://webmention.rocks/test/9
    context "when the `rel` attribute contains multiple space-separated values" do
      it_behaves_like "a Hash of endpoints" do
        let(:url) { "https://example.com/link_element_multiple_rel_values" }
      end
    end

    # Similar to https://webmention.rocks/test/12
    context "when the `rel` attribute contains similar values" do
      it_behaves_like "a Hash of endpoints" do
        let(:url) { "https://example.com/link_element_exact_match" }
      end
    end

    # Similar to https://webmention.rocks/test/13
    context "when the HTML contains an endpoint in an HTML comment" do
      it_behaves_like "a Hash of endpoints" do
        let(:url) { "https://example.com/link_element_html_comment" }
      end
    end

    # Similar to https://webmention.rocks/test/15
    context "when the `href` attribute is empty" do
      it_behaves_like "a Hash of endpoints" do
        let(:url) { "https://example.com/link_element_empty_href" }

        let(:endpoints) do
          {
            authorization_endpoint: "https://example.com/link_element_empty_href",
            "indieauth-metadata": "https://example.com/link_element_empty_href",
            micropub: "https://example.com/link_element_empty_href",
            microsub: "https://example.com/link_element_empty_href",
            redirect_uri: ["https://example.com/link_element_empty_href"],
            token_endpoint: "https://example.com/link_element_empty_href",
            webmention: nil
          }
        end
      end
    end

    # Similar to https://webmention.rocks/test/20
    context "when the `href` attribute does not exist" do
      it_behaves_like "a Hash of endpoints" do
        let(:url) { "https://example.com/link_element_no_href" }
      end
    end

    # Similar to https://webmention.rocks/test/21
    context "when `link` element references a URL with a query string" do
      it_behaves_like "a Hash of endpoints" do
        let(:url) { "https://example.com/link_element_query_string" }

        let(:endpoints) do
          {
            authorization_endpoint: "https://example.com/authorization_endpoint?query=yes",
            "indieauth-metadata": "https://example.com/indieauth-metadata?query=yes",
            micropub: "https://example.com/micropub?query=yes",
            microsub: "https://example.com/microsub?query=yes",
            redirect_uri: ["https://example.com/redirect?query=yes"],
            token_endpoint: "https://example.com/token_endpoint?query=yes",
            webmention: nil
          }
        end
      end
    end

    # Similar to https://webmention.rocks/test/22
    context "when the `link` element references a URL relative to the page" do
      it_behaves_like "a Hash of endpoints" do
        let(:url) { "https://example.com/link_element/relative_path" }

        let(:endpoints) do
          {
            authorization_endpoint: "https://example.com/link_element/relative_path/authorization_endpoint",
            "indieauth-metadata": "https://example.com/link_element/relative_path/indieauth-metadata",
            micropub: "https://example.com/link_element/relative_path/micropub",
            microsub: "https://example.com/link_element/relative_path/microsub",
            redirect_uri: ["https://example.com/link_element/relative_path/redirect"],
            token_endpoint: "https://example.com/link_element/relative_path/token_endpoint",
            webmention: nil
          }
        end
      end
    end

    context "when the `link` element references an invalid URL" do
      let(:url) { "https://example.com/link_element/invalid_href" }

      it "raises an IndieWeb::Endpoints::InvalidURIError" do
        stub_request(:get, url).to_return(response)

        expect { described_class.get(url) }.to raise_error(IndieWeb::Endpoints::InvalidURIError)
      end
    end

    context "when the `link` element references a URL with a fragment" do
      it_behaves_like "a Hash of endpoints" do
        let(:url) { "https://example.com/link_element_fragment" }

        let(:endpoints) do
          {
            authorization_endpoint: "https://example.com/authorization_endpoint",
            "indieauth-metadata": "https://example.com/indieauth-metadata",
            micropub: "https://example.com/micropub",
            microsub: "https://example.com/microsub",
            redirect_uri: ["https://example.com/redirect_uri"],
            token_endpoint: "https://example.com/token_endpoint",
            webmention: nil
          }
        end
      end
    end
  end
end
