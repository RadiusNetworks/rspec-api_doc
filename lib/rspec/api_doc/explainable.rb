require_relative 'strings'

module RSpec
  module ApiDoc
    module Explainable
      def append_explanation(text)
        explanation_parts << Strings.strip_heredoc(text).chomp
      end

      def append_paragraph(text)
        explanation_parts << Strings.squish(text).chomp
      end

      def explanation
        # End the text and add a empty line to separate paragraphs
        explanation_parts.join("\n\n")
      end

      def explanation_parts
        @explanation_parts ||= []
      end
      private :explanation_parts
    end
  end
end
