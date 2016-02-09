module CoverMyMeds
  module Error
    class HTTPError < StandardError

      def initialize status, message, http_method, rest_resource
        @status = status
        @error_json = message
        @http_method = http_method
        @rest_resource = rest_resource
      end

      def message
        <<-EOS.gsub(/^ {10}/, "")
          #{@status}: #{@error_json}
          in response to:
          #{@http_method.upcase} #{@rest_resource}
        EOS
      end

      attr_reader :status, :error_json, :http_method, :rest_resource

    end

    CMMDuplicateEntityError = Class.new(StandardError)
  end
end
