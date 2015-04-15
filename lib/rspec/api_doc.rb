require "rspec/api_doc/version"

module RSpec
  module ApiDoc
    autoload :DSL, "rspec/api_doc/dsl"
  end
end

require 'rspec/api_doc/railtie' if defined?(Rails)
