module RSpec
  module ApiDoc
    class StandardCurlExample
      attr_reader :section
      private :section

      def initialize(section)
        @section = section
      end

      def build
        "curl #{section.request_url} \\\n" + parts.join(" \\\n").indent(2)
      end

    private

      def as_data(string)
        # Curl does not like single quotes in a string
        string.gsub("'", '\u0027')
      end

      def headers
        headers = []
        section.request_headers do |header|
          headers << "-H '#{as_data("#{header.name}: #{header.content}")}'"
        end
        headers
      end

      def json
        section.request_json ? ["-d '#{as_data(section.request_json)}'"] : []
      end

      def options
        ["-is", "-X #{section.http_method}"]
      end

      def parts
        options.concat(headers).concat(json)
      end
    end
  end
end
