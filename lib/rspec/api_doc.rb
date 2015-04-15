require "rspec/api_doc/version"
require 'rspec/core'

module RSpec
  module ApiDoc
    autoload :DSL, "rspec/api_doc/dsl"
  end
end

require 'rspec/api_doc/railtie' if defined?(Rails)

RSpec.configure do |c|
  c.extend RSpec::ApiDoc::DSL, :api_doc
  c.alias_example_group_to :document, :generate_doc
  c.alias_example_to :record, :record

  c.after(:each, :record) do |ex|
    group = ex.example_group
    group.request, group.response = request, response
  end
end
