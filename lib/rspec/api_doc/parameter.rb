module RSpec
  module ApiDoc
    Parameter = Struct.new(:name, :description, :type, :required) do
      def required?
        !!required
      end
    end
  end
end
