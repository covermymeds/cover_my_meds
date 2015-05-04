require "covermymeds_api/version"
require_relative 'covermymeds_api/meta'
require_relative 'covermymeds_api/client'

module CoverMyMeds

  GET    = 'get'.freeze
  POST   = 'post'.freeze
  PUT    = 'put'.freeze
  DELETE = 'delete'.freeze

  def self.version
    "CoverMyMeds version #{CoverMyMeds::VERSION}"
  end

end
