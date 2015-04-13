require 'rspec/api_doc'

RSpec.describe RSpec::ApiDoc do
  it 'has a version number' do
    expect(RSpec::ApiDoc::VERSION).not_to be nil
  end
end
