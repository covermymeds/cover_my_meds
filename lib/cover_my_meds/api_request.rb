require 'rest-client'
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

      tail = case auth_type
        when :basic
          { user: @username, password: @password, headers: headers }
        when :bearer
          { headers: { "Authorization" => "Bearer #{@username}+#{params.delete(:token_id)}" }.merge(headers) }
        else
          {}
      end

      uri = api_uri(host, path, params)
      rest_resource = RestClient::Resource.new(uri.to_s, tail)

      response = call_api http_method, rest_resource, &block
      parse_response response
    end

    def parse_response response
      return nil if response.body.empty?
      JSON.parse(response.body)
    rescue JSON::ParserError
      response.body
    end

    def call_api http_method, rest_resource
      body = block_given? ? yield : {}
      rest_resource.send http_method, body
    rescue RestClient::Exception => e
      raise Error::HTTPError.new(e.http_code, e.http_body)
    end

    def api_uri host, path, params
      URI.parse(host).tap do |uri|
        uri.path  = path
        uri.query = params.to_param
      end
    end
  end
end
