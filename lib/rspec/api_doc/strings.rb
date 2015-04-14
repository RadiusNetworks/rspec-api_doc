require 'uri'

module RSpec
  module ApiDoc
    module Strings
    module_function

      def pretty_escape(text, sep = '-')
        URI.escape(text.strip.gsub(/[[:space:]]+/, sep))
      end

      # Source 'active_support/core_ext/string/inflections'
      def titleize(text)
        text.gsub(/\b(?<!['’`])[a-z]/) { $&.capitalize }
      end

      # Source 'active_support/core_ext/string/filters'
      def squish(text)
        text.gsub(/[[:space:]]+/, ' ').strip
      end

      # Source 'active_support/core_ext/string/strip'
      def strip_heredoc(text)
        # TODO: REMOVE TRY!
        indent = text.scan(/^[ \t]*(?=\S)/).min.try(:size) || 0
        text.gsub(/^[ \t]{#{indent}}/, '')
      end

      def blank?(text)
        text.nil? || /\A[[:space:]]*\z/ =~ text
      end
    end
  end
end
