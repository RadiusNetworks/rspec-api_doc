module RSpec
  module ApiDoc
    # Railtie to hook into Rails.
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load "rspec/api_doc/generate.rake"
      end
    end
  end
end
