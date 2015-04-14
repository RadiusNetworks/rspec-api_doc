RSpec.describe "RSpec::ApiDoc" do
  it 'requires rspec-core to have been loaded' do
    command = ['ruby', '-Ilib', '-e', 'require "rspec/api_doc"']
    output = IO.popen(command, err: %i[ child out ])

    expect(output.read).to include("rspec-core is not loaded (RuntimeError)")
  end

  it 'requires rack-test to have been loaded' do
    command = [
      "ruby",
      "-Ibundle",
      "-Ilib",
      "-e",
      'require "rspec/core"; require "rspec/api_doc"',
    ]
    output = IO.popen(command, err: %i[ child out ])

    expect(output.read).to include("rack-test is not loaded (RuntimeError)")
  end
end
