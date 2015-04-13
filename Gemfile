source 'https://rubygems.org'

# Specify your gem's dependencies in rspec-api_doc.gemspec
gemspec

group :development do
  gem 'rubocop', '~> 0.30.0', require: false
end

group :documentation do
  gem 'yard', '~> 0.8.7', require: false

  ### deps for rdoc.info
  gem 'redcarpet',     '2.1.1', platform: :mri
  gem 'github-markup', '0.7.2', platform: :mri
end

custom_gemfile = File.expand_path("../Gemfile-custom", __FILE__)
eval_gemfile custom_gemfile if File.exist?(custom_gemfile)
