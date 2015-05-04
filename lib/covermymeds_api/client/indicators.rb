module CoverMyMeds
  module Indicators
    include HostAndPath

    CURRENT_VERSION = 1

    def post_indicators(prescriptions, patient = {}, payer = {}, version = CURRENT_VERSION)
      params = { prescriptions: prescriptions, patient: patient, payer: payer }
      data = indicators_request POST, params: { v: version, headers: { content_type: :json } } do
        params.to_json
      end
      Hashie::Mash.new(data)
    end
  end
end
