require 'rspec/api_doc/document'

module RSpec
  module ApiDoc
    RSpec.describe Document do
      it "provides access to it's binding" do
        example_group = double(
          "ExampleGroup",
          description:       "The example title",
          resource:          :a_resource,
          explanation_parts: [],
        )
        a_document = Document.new(example_group)
        the_binding = a_document.to_binding
        # rubocop:disable Lint/Eval
        expect(eval("title", the_binding)).to eq "The Example Title"
        # rubocop:enable Lint/Eval
      end
    end
  end
end
