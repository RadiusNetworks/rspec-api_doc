RSpec.describe "Code Style" do
  it "meets the defined style guidelines" do
    expect(`bin/rubocop --format clang`).to include "no offenses detected"
  end
end
