module CoverMyMeds
  module Error
    class HTTPError < StandardError

      def initialize status, message
        @status = status
        @error_json = message
      end

      def message
        "#{@status}: #{@error_json}"
      end

      attr_reader :status, :error_json

    end

    CMMDuplicateEntityError = Class.new(StandardError)
  end
end
