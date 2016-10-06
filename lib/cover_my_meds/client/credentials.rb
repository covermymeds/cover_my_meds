module CoverMyMeds
  module Credentials
    include HostAndPath

    CURRENT_VERSION = 1

    def create_credential npi: npi(), callback_url: '', callback_verb: '', fax_numbers: fax_numbers(), contact_hint: {}, version: CURRENT_VERSION
      params = { v: version }
      data = credentials_request POST, params: params do
        {
          credential: {
            npi: npi,
            callback_url: callback_url,
            callback_verb: callback_verb,
            fax_numbers: Array(fax_numbers),
            contact_hint: contact_hint,
          }
        }
      end
      Hashie::Mash.new data['credential']
    end

    # Override the meta-programming in this oddball case
    def credentials_path
      @credentials_path || "/prescribers/credentials/"
    end

    def delete_credential(npi, version=CURRENT_VERSION)
      data = credentials_request DELETE, path: npi, params: { v: version }
    end
  end
end
