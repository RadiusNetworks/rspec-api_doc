lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/api_doc/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-api_doc"
  spec.version       = RSpec::ApiDoc::VERSION
  spec.authors       = ["Radius Networks"]
  spec.email         = ["support@radiusnetworks.com"]

  spec.summary       = "Mini DSL on top of RSpec for writing API docs"
  spec.description   = <<-DESC.strip
    Mini DSL built on RSpec for writing executable API docs for Rack apps.
  DESC
  spec.homepage      = "https://github.com/radiusnetworks/rspec-api_doc"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/})
  }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.5'

  spec.add_runtime_dependency "rack-test", ">= 0.6.3"
  spec.add_runtime_dependency "rspec-core", "~> 3.2"

  spec.add_development_dependency "bundler", ">= 1.9"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "radius-spec"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.2"
end
