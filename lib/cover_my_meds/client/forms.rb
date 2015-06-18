module CoverMyMeds
  module Forms
    include HostAndPath

    CURRENT_VERSION = 1

    def form_search form, drug_id, state, version=CURRENT_VERSION
      params = {q: form, drug_id: drug_id, state: state, v: version}
      data = forms_request GET, params: params
      data['forms'].map { |d| Hashie::Mash.new(d) }
    end

    def get_form form_id, version = CURRENT_VERSION
      data = forms_request GET, params: { v: version }, path: form_id
      Hashie::Mash.new(data['form'])
    end
  end
end
