# RSpec API Documenter [![Build Status](https://travis-ci.org/RadiusNetworks/rspec-api_doc.svg?branch=master)](https://travis-ci.org/RadiusNetworks/rspec-api_doc) [![Code Climate](https://codeclimate.com/github/RadiusNetworks/rspec-api_doc/badges/gpa.svg)](https://codeclimate.com/github/RadiusNetworks/rspec-api_doc)

Generate markdown based API documentation from your executable specs.

This provides a small DSL extension to RSpec. It leverages the structure of
[`Rack::Test`](https://github.com/brynary/rack-test) to record the spec's
request / response with your web app.

This currently only supports JSON based APIs.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'rspec-api_doc', group: [:test, :development]
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install rspec-api_doc
```

## Setup

Require the gem at the top of your spec file:

```ruby
require 'rspec/api_doc'
```

We do _not_ suggest adding this to your `spec/spec_helper.rb` or
`spec/rails_helper.rb` files. This advice is in-line with the RSpec
recommendation that you should keep your common base configuration files as
lightweight as possible.

If you are a fan of metadata, you can have the DSL included automatically for
you by adding `:api_doc` to the example group. Otherwise, you can manually
include it:

```ruby
extend RSpec::ApiDoc::DSL
```

## Usage

The DSL extensions are available to use along side the existing RSpec syntax:

```ruby
require 'rails_helper'
require 'rspec/api_doc'

RSpec.describe "My API Root Endpoint", :api_doc, type: :request do

  resource_endpoint '/api/v1'

  use_host 'https://mydomain.com'

  explanation <<-EOP
    This describes the resources that make up the official Widget Inc. API v1.
    If you have any problems or requests please contact support.

    Issue a `GET` request to the root endpoint to get a list of all the
    resource endpoints this API supports.
  EOP

  shared_context "general headers" do
    def json_authorization_headers(token = "0123456789abcdef")
      json_content_headers.merge('AUTHORIZATION' => :Token token=\"#{token}\")
    end

    header 'Authorization', 'Token token="0123456789abcdef"'

    explanation <<-SECTION
      ## Headers <a href="#headers" id="headers" class="headerlink"></a>

      The API Key is passed via the Authorization header:

      ```
      Authorization: Token token="0123456789abcdef"
      ```

      **Note:** Per RFC 2616 the Authorization Header's token needs to be surrounded
      by double quotes (`"`).
    SECTION
  end

  include_section "general headers"

  document "requesting resource endpoints" do
    it "requires token authentication" do
      get resource_endpoint, nil, json_content_headers
      expect(response).to have_http_status(:unauthorized)
    end

    record "lists all of the available resource endpoint URIs" do
      get resource_endpoint, nil, json_authorization_headers
      expect(response).to have_http_status(:success).and(
        have_content_type(:json)
      )
      expect(response.body).to include(
        '"users.widgets":"https://mydomain.com/api/v1/widgets/{users.widgets}"'
      )
    end
  end

end
```

Generate the API documentation by running:

```console
$ rake doc:api
```

The default location for the generated markdown files is `docs/`. We suggest
you add this to your `.gitignore` if it is not already present.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment. Run
`bundle exec rspec-api_doc` to use the code located in this directory, ignoring
other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

1. Fork it ( https://github.com/radiusnetworks/rspec-api_doc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
