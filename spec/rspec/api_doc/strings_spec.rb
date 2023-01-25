require 'rspec/api_doc/strings'

module RSpec
  module ApiDoc
    RSpec.describe Strings do
      describe ".pretty_escape" do
        let(:expected_string) { 'three-little-birds' }
        it "removes leading and trailing whitespace and replaces spaces with hyphens" do
          text = " three little birds "
          expect(subject.pretty_escape(text)).to eq(expected_string)
        end

        it "accepts a custom separator as a second argument" do
          text = ' three little birds '
          sep = 'z'
          expect(subject.pretty_escape(text, sep)).to eq(expected_string.gsub('-', sep))
        end

        it "replaces two spaces with a single hyphen" do
          text = 'three  little  birds'
          expect(subject.pretty_escape(text)).to eq(expected_string)
        end
      end

      describe ".titleize" do
        let(:expected_string) { 'Three Little Birds' }
        it "capitalizes the first letter of each word" do
          text = 'three little birds'
          expect(subject.titleize(text)).to eq(expected_string)
        end

        it "does not capitalize the first letter of the word begins with a single quote" do
          %w[' ’ `].each do |single_quote|
            text = "#{single_quote}three little birds"
            expect(subject.titleize(text)).to eq(expected_string.gsub('T', "#{single_quote}t"))
          end
        end
      end

      describe ".squish" do
        let(:expected_string) { 'three little birds' }
        it "compresses sequential spaces down to a single space" do
          text = 'three      little    birds'
          expect(subject.squish(text)).to eq(expected_string)
        end
      end

      describe ".strip_heredoc" do
        let(:expected_string) { 'three little birds' }
        it "removes all tabs and spaces from the beginning of lines" do
          text = "\t\t\t  three little birds"
          expect(subject.strip_heredoc(text)).to eq(expected_string)
        end
      end

      describe ".blank?" do
        it "returns true if the text is nil" do
          expect(subject.blank?(nil)).to be_truthy
        end

        it "returns true if the text contains only spaces" do
          expect(subject.blank?('          ')).to be_truthy
        end
      end
    end
  end
end
