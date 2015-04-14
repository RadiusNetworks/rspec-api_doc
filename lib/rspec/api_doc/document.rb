require_relative 'explainable'
require_relative 'strings'

module RSpec
  module ApiDoc
    class Document
      include Explainable

      # Expose this object's binding
      def to_binding
        binding
      end

      attr_reader :resource, :sections, :title

      def initialize(example_group)
        @title = Strings.titleize(example_group.description.strip)
        @resource = example_group.resource
        @explanation_parts = example_group.explanation_parts
        @sections = []
      end
    end
  end
end
