require 'json'
require 'rack'
require_relative 'explainable'
require_relative 'header'
require_relative 'strings'

module RSpec
  module ApiDoc
    class Section
      include Explainable

      attr_reader :parameters,
                  :custom_parameters_info,
                  :header,
                  :header_ref,
                  :example_explanation

      def initialize(example_group)
        @header = Strings.titleize(example_group.description.strip)
        @header_ref = Strings.pretty_escape(@header.downcase)
        @parameters = example_group.parameters
        @custom_parameters_info = example_group.custom_parameters_info
        @explanation_parts = example_group.explanation_parts
        @example_explanation = example_group.example_explanation
        # Necessary for now to get the request and response
        @_group = example_group
      end

      def parameters?
        !parameters.empty?
      end

      def parameters(&block)
        if block_given?
          @parameters.each(&block)
        else
          @parameters
        end
      end

      def http_method
        @_group.request.method unless @_group.request.nil?
      end

      def request_path
        @_group.request.path_info unless @_group.request.nil?
      end

      def recorded_request?
        !@_group.request.nil?
      end

      def recorded_response?
        !@_group.response.nil?
      end

      def response_status
        code = @_group.response.status
        title = ::Rack::Utils::HTTP_STATUS_CODES[code]
        "#{code} #{title}"
      end

      def response_type
        @_group.response.content_type
      end

      def request_json
        return if Strings.blank?(@_group.request.body.string)
        JSON.pretty_generate(JSON.parse(@_group.request.body.string))
      end

      def response_json
        return unless response_json_body
        JSON.pretty_generate(response_json_body)
      end

      def response_json_body
        body = @_group.response.body
        JSON.parse(body) unless Strings.blank?(body)
      end

      def include_headers
        @_group.metadata['include_headers'] ||= {}
      end

      def request_headers(&block)
        actual = @_group.request.headers
        include_headers.each_with_object([]) { |(name, content), display|
          content ||= actual[name]
          display << Header.new(name, content) if content
        }.each(&block)
      end

      def response_headers(&block)
        actual = @_group.response.headers
        include_headers.each_with_object([]) { |(name, _), display|
          content = actual[name]
          display << Header.new(name, content) if content
        }.each(&block)
      end

      def request_url
        @_group.request.original_url
      end
    end
  end
end
