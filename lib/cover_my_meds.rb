require "cover_my_meds/version"
require_relative 'cover_my_meds/meta'
require_relative 'cover_my_meds/client'

require 'cover_my_meds/railtie' if defined?(Rails)

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
