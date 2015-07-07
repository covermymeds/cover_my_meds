module CoverMyMeds
  class Railtie < Rails::Railtie
    config.cover_my_meds = ActiveSupport::OrderedOptions.new

    config.cover_my_meds.default_host = "https://api.covermymeds.com/"

    # Create (and cache) a configured API client instance using the id/secret
    # stored in `Rails.application.secrets` and the configuration specified
    # here and in `Rails.application.config.covermymeds`
    def default_client
      @client ||= configured_client *credentials
    end

    # Create a configured API client class with the configuration stored on the
    # app.  Useful if you want to use the same host/path configuration as the
    # rest of the app, but a different id/secret pair
    def configured_client(api_id, secret = nil)
      CoverMyMeds::Client.new api_id, secret do |client|
        config.cover_my_meds.each do |k,v|
          client.send "#{k}=".to_sym, v
        end
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
