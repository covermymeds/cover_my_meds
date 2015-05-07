module CoverMyMeds
  class Railtie < Rails::Railtie
    config.covermymeds_api = ActiveSupport::OrderedOptions.new

    config.covermymeds_api.default_host = "https://api.covermymeds.com/"

    # Create (and cache) a configured API client instance using the id/secret
    # stored in `Rails.application.secrets` and the configuration specified
    # here and in `Rails.application.config.covermymeds_api`
    def default_client
      return @client if @client
      @client = CoverMyMeds::Client.new *credentials do |client|
        configure_client client
      end
    end

    # Configure an API client class with the configuration stored on the app.
    # Useful if you want to use the same host/path configuration as the rest of
    # the app, but a different id/secret pair
    def configure_client(client)
      config.covermymeds_api.each do |k,v|
        client.send "#{k}=".to_sym, v
      end
    end

    private
    def credentials
      api_id = Rails.application.secrets.cmm_api_id || ENV['CMM_API_ID']
      secret = Rails.application.secrets.cmm_api_secret || ENV['CMM_API_SECRET']
      [ api_id, secret ]
    end
  end
end
