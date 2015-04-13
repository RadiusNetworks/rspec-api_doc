fail "rspec-core is not loaded" unless defined?(RSpec::Core)
fail "rack-test is not loaded" unless defined?(Rack::Test)

require "rspec/api_doc/version"

module RSpec
  module ApiDoc
    # Your code goes here...
  end
end
