module CoverMyMeds
  module Pharmacies
    include HostAndPath

    CURRENT_VERSION = 1

    def pharmacy_search params, version=CURRENT_VERSION
      params.merge!(v: version)
      data = pharmacies_request GET, params: params
      data['pharmacies'].map do |d|
        Hashie::Mash.new(d)
      end
    end

    def get_pharmacy npi, version = CURRENT_VERSION
      data = pharmacies_request GET, params: { v: version }, path: npi
      Hashie::Mash.new(data['pharmacy'])
    end
  end
end
