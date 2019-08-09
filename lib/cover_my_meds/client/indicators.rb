module CoverMyMeds
  module Indicators
    include HostAndPath

    CURRENT_VERSION = 1

    def post_indicators(prescription: prescription(), patient: patient(), payer: {}, prescriber: {}, pharmacy: {}, rxnorm: nil, version: CURRENT_VERSION)
      params = { prescription: prescription, prescriber: prescriber, patient: patient, payer: payer, pharmacy: pharmacy, rxnorm: rxnorm }
      data = indicators_request POST, params: { v: version, headers: { content_type: "application/json" } } do
        params.to_json
      end
      data
    end

    def search_indicators(prescriptions: prescriptions(), patient: {}, payer: {}, prescriber: {}, version: CURRENT_VERSION)
      params = { prescriptions: Array(prescriptions), prescriber: prescriber, patient: patient, payer: payer }
      data = indicators_request POST, path: 'search/', params: { v: version, headers: { content_type: "application/json" } } do
        params.to_json
      end
      data
    end

  end
end
