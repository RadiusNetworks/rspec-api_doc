require 'erb'
require 'pathname'
require_relative 'document'
require_relative 'section'
require_relative 'standard_curl_example'

module RSpec
  module ApiDoc
    class JsonApiFormatter
      ::RSpec::Core::Formatters.register self,
                                         *%i[
                                           example_group_started
                                           example_group_finished
                                         ]
      def self.doc_dir
        @doc_dir ||= Pathname(root.join('docs'))
      end

      def self.doc_dir=(dir)
        @doc_dir = Pathname(dir)
      end

      def self.root
        # FIXME: Shortcut assuming we are run from the project root
        Pathname.getwd
      end

      def self.spec_dirname=(dir)
        @spec_dirname = Pathname(dir)
      end

      def self.spec_dirname
        @spec_dirname ||= Pathname('./spec/requests')
      end

      def self.template=(path)
        @template = Pathname(path)
      end

      def self.template
        @template || Pathname(__dir__).join(
          'templates', 'api_doc_json_template.md.erb'
        )
      end

      attr_reader :group_level

      # @see RSpec::Core::Formatters::Protocol#initialize
      def initialize(_ignore_output)
        @group_level = 0
      end

      def example_group_started(notification)
        group = notification.group
        if api_document?(group)
          new_document group
        elsif group.metadata[:generate_doc]
          add_section group
        end
        @group_level += 1
      end

      def example_group_finished(notification)
        group = notification.group
        @group_level -= 1
        write_document document_file(group) if api_document?(group)
      end

    private

      attr_reader :document

      def api_document?(group)
        group_level == 0 && group.metadata[:doc] == :json_api
      end

      def new_document(group)
        @document = Document.new(group)
      end

      def add_section(group)
        document.sections << Section.new(group)
      end

      def create_doc_dir
        @doc_dir = self.class.doc_dir
        doc_dir.mkpath unless doc_dir.directory?
      end

      def document_file(group)
        spec_dir, spec_file = Pathname(group.file_path).split
        spec_file = spec_file_basename(spec_file)
        document_dir(spec_dir).join(spec_file.sub_ext('.md'))
      end

      def document_dir(spec_dir)
        self.class
            .doc_dir
            .join(spec_dir.relative_path_from(self.class.spec_dirname))
      end

      def spec_file_basename(path)
        remove_spec_suffix(drop_extension(path))
      end

      def drop_extension(filename)
        filename.basename(filename.extname)
      end

      def remove_spec_suffix(filename)
        Pathname(filename.to_path.chomp('_spec'))
      end

      def write_document(file)
        dirname, _basename = file.split
        dirname.mkpath unless dirname.directory?
        file.write template.result(document.to_binding)
      end

      def template
        # This is a formatter, so meh about safe level
        @template ||= ERB.new(
          File.read(self.class.template),
          _safe_level = nil,
          _trim_mode = '<>',
        )
      end
    end
  end
end
