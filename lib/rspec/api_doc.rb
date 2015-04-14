fail "rspec-core is not loaded" unless defined?(RSpec::Core)
fail "rack-test is not loaded" unless defined?(Rack::Test)

require "rspec/api_doc/version"

module RSpec
  module ApiDoc
    autoload :DSL, "rspec/api_doc/dsl"
  end
end
