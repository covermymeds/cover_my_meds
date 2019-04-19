module CoverMyMeds
  module Error
    class HTTPError < StandardError

      def initialize status, message, http_method, url
        @status = status
        @error_json = message
        @http_method = http_method
        @url = url
      end

      def message
        <<-EOS.gsub(/^ {10}/, "")
          #{@status}: #{@error_json}
          in response to:
          #{@http_method.upcase} #{@url}
        EOS
      end

      attr_reader :status, :error_json, :http_method, :url

    end

    CMMDuplicateEntityError = Class.new(StandardError)
  end
end
