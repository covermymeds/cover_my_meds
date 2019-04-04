require_relative 'api_request'
require_relative 'client/consumers'
require_relative 'client/drugs'
require_relative 'client/forms'
require_relative 'client/requests'
require_relative 'client/tokens'
require_relative 'client/credentials'
require_relative 'client/request_pages'
require_relative 'client/indicators'

module CoverMyMeds
  class Client
    include CoverMyMeds::ApiRequest
    include CoverMyMeds::Consumers
    include CoverMyMeds::Drugs
    include CoverMyMeds::Forms
    include CoverMyMeds::Requests
    include CoverMyMeds::Tokens
    include CoverMyMeds::Credentials
    include CoverMyMeds::RequestPages
    include CoverMyMeds::Indicators

    # use the block to set module privided instance variables:
    # ```ruby
    # Client.new('mark') do |client|
    #   client.contacts_path = '/'
    #   client.contacts_host = 'http://contacts-api.dev'
    # end
    # ```
    #
    # Defaults are to proudction to make it easy for external gem consumers.
    def initialize(username, password=nil)
      @username = username
      @password = password
      yield(self) if block_given?
    end

    attr_writer :default_host
    def default_host
      @default_host ||= "https://api.covermymeds.com"
    end

    def disable_hashie_log
      Hashie.logger = Logger.new('/dev/null')
    end
  end
end
