require 'rest-client'
require 'curl'
require 'json'
require 'hashie'
require 'active_support/core_ext/object/to_param'
require 'active_support/core_ext/object/to_query'
require 'cover_my_meds/error'

module CoverMyMeds
  module ApiRequest

    def request(http_method, host, path, params={}, auth_type = :basic, &block)
      params  = params.symbolize_keys
      headers = params.delete(:headers) || {}

      c = Curl::Easy.new
      c.headers = headers

      if auth_type == :basic
        c.http_auth_types = :basic
        c.username = @username
        c.password = @password
      elsif auth_type == :bearer
        c.headers["Authorization"] = "Bearer #{@username}+#{params.delete(:token_id)}"
      end


      uri = api_uri(host, path, params)
      c.url = uri.to_s
      c.send(http_method)

      if c.status.first != "2"
        raise Error::HTTPError.new(c.status[0..2], c.body_str, http_method, uri.to_s)
      end

      parse_response c.body_str
    end

    def parse_response response
      return nil if response.empty?
      JSON.parse(response)
    rescue JSON::ParserError
      response
    end

    def call_api http_method, rest_resource
      body = block_given? ? yield : {}
      rest_resource.send http_method, body
    rescue RestClient::Exception => e
      raise Error::HTTPError.new(e.http_code, e.http_body, http_method, rest_resource)
    end

    def api_uri host, path, params
      URI.parse(host).tap do |uri|
        uri.path  = path
        uri.query = params.to_param
      end
    end
  end
end
