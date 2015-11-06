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
        "#{@status}: #{@error_json}\n"+
        "in response to:\n"+
        "#{@http_method.upcase} #{@rest_resource}\n"
      end

      attr_reader :status, :error_json, :http_method, :rest_resource

    end

    CMMDuplicateEntityError = Class.new(StandardError)
  end
end
