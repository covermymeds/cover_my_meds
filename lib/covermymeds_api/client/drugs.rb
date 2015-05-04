module CoverMyMeds
  module Drugs
    include HostAndPath

    CURRENT_VERSION = 1

    def drug_search drug, version=CURRENT_VERSION
      params = {q: drug, v: version}
      data = drugs_request GET, params: params
      data['drugs'].map { |d| Hashie::Mash.new(d) }
    end

    def get_drug drug_id, version = CURRENT_VERSION
      data = drugs_request GET, params: { v: version }, path: drug_id
      Hashie::Mash.new(data['drug'])
    end
  end
end
