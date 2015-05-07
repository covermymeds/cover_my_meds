require "covermymeds_api/version"
require_relative 'covermymeds_api/meta'
require_relative 'covermymeds_api/client'

require 'covermymeds_api/railtie' if defined?(Rails)

module CoverMyMeds

  GET    = 'get'.freeze
  POST   = 'post'.freeze
  PUT    = 'put'.freeze
  DELETE = 'delete'.freeze

  def self.version
    "CoverMyMeds version #{CoverMyMeds::VERSION}"
  end

  def self.default_client
    # Delegate to the Railtie if it's there
    if defined?(Railtie)
      Railtie.instance.default_client
    else
      Client.new ENV['CMM_API_ID'], ENV['CMM_API_SECRET']
    end
  end
end
