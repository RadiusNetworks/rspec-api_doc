source 'https://rubygems.org'

# Specify your gem's dependencies in rspec-api_doc.gemspec
gemspec

gem 'rubocop', '~> 0.65.0', require: false, group: %i[development test]

group :documentation do
  gem 'yard', '~> 0.9.18', require: false

  ### deps for rdoc.info
  gem 'github-markup', '0.7.2', platform: :mri
  gem 'redcarpet',     '2.1.1', platform: :mri
end

custom_gemfile = File.expand_path("Gemfile-custom", __dir__)
eval_gemfile custom_gemfile if File.exist?(custom_gemfile)
