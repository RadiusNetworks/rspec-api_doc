require 'rspec/core/rake_task'

unless Rake::Task.task_defined?("spec:prepare")
  namespace :spec do
    task :prepare do
      ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'
    end
  end
end

namespace :doc do
  desc "Run all specs in spec directory (excluding plugin specs)"
  RSpec::Core::RakeTask.new(api: 'spec:prepare') do |t|
    t.rspec_opts = %w[
      --tag generate_doc
      --format doc
      --format RSpec::ApiDoc::JsonApiFormatter
      --order defined
    ]
  end
end
