require_relative 'parameter'

module RSpec
  module ApiDoc
    module DSL
      def metadata_macro(name)
        define_method(name) do |value = nil|
          if value
            let(name) { value.dup }
            metadata[name.to_sym] = value
          end
          metadata[name.to_sym]
        end
      end
      module_function :metadata_macro

      # Use the metadata to store these so they are available in nested groups
      # and examples
      metadata_macro :resource

      def endpoint_macro(name)
        define_method(name) do |value = nil|
          set_endpoint(name, value)
          metadata[name.to_sym]
        end
      end
      module_function :endpoint_macro

      endpoint_macro :resource_endpoint
      endpoint_macro :collection_endpoint

      def use_host(host)
        uri = URI.parse(host)
        host = uri.host
        protocol = uri.scheme || "https"
        around do |ex|
          org_host = default_url_options[:host]
          org_protocol = default_url_options[:protocol]
          default_url_options[:host] = host
          default_url_options[:protocol] = protocol
          ex.run
          # Rails dislikes an explicit `nil` as the host, so check first
          if org_host
            default_url_options[:host] = org_host
          else
            default_url_options.delete(:host)
          end
          if org_protocol
            default_url_options[:protocol] = org_protocol
          else
            default_url_options.delete(:protocol)
          end
        end
      end

      def example_explanation(text = nil)
        @_example_explanation = text.strip_heredoc if text
        @_example_explanation
      end

      def explanation(text)
        explanation_parts << text.strip_heredoc.chomp
      end

      def paragraph(text)
        explanation_parts << text.squish.chomp
      end

      def include_section(name)
        # Easiest if for this to simply be an include shared_context alias
        # which we would need to create a custom macro alias for
        # `shared_context`. However, this would require the writer to
        # understand our "section" nesting formatting :-/
        include_context(name)
      end

      def header(name, static_value = nil)
        metadata['include_headers'] ||= {
          'Accept'       => nil,
          'Content-Type' => nil,
        }
        metadata['include_headers'][name] = static_value
      end

      # This sets a class variable which is distict per group; it is not
      # inherited by nested groups
      def explanation_parts
        @explanation_parts ||= []
      end

      def parameter(name, description, type: :string, required: false)
        parameters << Parameter.new(name, description, type, required)
      end

      def parameters
        @parameters ||= []
      end

      def parameters_info(value)
        @custom_parameters_info = value
      end

      def custom_parameters_info
        @custom_parameters_info
      end

      attr_accessor :response, :request, :include_headers

    private

      def set_endpoint(key, value)
        return if value.nil?
        # Set the full URL when customized so the controller has it
        let(key) {
          if default_url_options[:host]
            "#{default_url_options[:host]}#{value}"
          else
            value.dup
          end
        }
        metadata[key.to_sym] = value
      end
    end
  end
end
