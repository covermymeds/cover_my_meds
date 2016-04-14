module CoverMyMeds
  module Requests
    include HostAndPath

    CURRENT_VERSION = 1

    def get_request token_id, version = CURRENT_VERSION
      params = { v: version }
      data = requests_request POST, params: params, path: "search/" do
        "token_ids[]=#{token_id}"
      end
      Hashie::Mash.new(data['requests'].first)
    end

    def get_requests token_ids, version = CURRENT_VERSION
      params = { 'token_ids' => token_ids, v: version }
      data = requests_request POST, params: params, path: "search/"
      data['requests'].map { |d| Hashie::Mash.new(d) }
    end

    def create_request request_data,version = CURRENT_VERSION
      data = requests_request POST, params: { v: version } do
        { 'request' => request_data.to_hash }
      end
      Hashie::Mash.new(data['request'])
    end

    def send_to_plan_request request_id, token_id, fax_params = {}, version = "1"
      params = { token_id: token_id, v: version }

      error_msg = ""
      [ :office_fax, :from_fax ].each do |param|
        error_msg = "#{param} is required. " unless fax_params[param]
      end
      raise ArgumentError.new(error_msg) unless error_msg == ""

      data = requests_request POST, params: params, path: "#{request_id}/send_to_plan", auth: :bearer do
        fax_params
      end

      Hashie::Mash.new data['request']
    end

    def archive_request request_id, token_id, archive_params = {}, version = "1"
      params = { token_id: token_id, v: version }

      data = requests_request POST, params: params, path: "#{request_id}/archive", auth: :bearer do
        archive_params
      end

      Hashie::Mash.new data['request']
    end

    def request_data
      hash = JSON.parse @@json_string
      Hashie::Mash.new hash['request']
    end

    @@json_string = <<-eof
{
  "request": {
    "urgent": "false",
    "form_id": "",
    "state": "",
    "memo": "",
    "patient": {
      "first_name": "",
      "middle_name": "",
      "last_name": "",
      "date_of_birth": "",
      "gender": "",
      "email": "",
      "member_id": "",
      "phone_number": "",
      "address": {
        "street_1": "",
        "street_2": "",
        "city": "",
        "state": "",
        "zip": ""
      }
    },
    "payer": {
      "form_search_text": "",
      "bin": "",
      "pcn": "",
      "group_id": "",
      "medical_benefit_name": "",
      "drug_benefit_name": ""
    },
    "prescriber": {
      "npi": "",
      "first_name": "",
      "last_name": "",
      "clinic_name": "",
      "speciality": "",
      "address": {
        "street_1": "",
        "street_2": "",
        "city": "",
        "state": "",
        "zip": ""
      },
      "fax_number": "",
      "phone_number": ""
    },
    "prescription": {
      "drug_id": "",
      "strength": "",
      "frequency": "",
      "enumerated_fields": "",
      "refills": "",
      "dispense_as_written": "",
      "quantity": "",
      "days_supply": ""
    },
    "pharmacy": {
      "name": "",
      "address": {
        "street_1": "",
        "street_2": "",
        "city": "",
        "state": "",
        "zip": ""
      },
      "fax_number": "",
      "phone_number": ""
    },
    "enumerated_fields": {
      "icd9_0": "",
      "icd9_1": "",
      "icd9_2": "",
      "failed_med_0": "",
      "failed_med_1": "",
      "failed_med_2": "",
      "failed_med_3": "",
      "failed_med_4": "",
      "failed_med_5": "",
      "failed_med_6": "",
      "failed_med_7": "",
      "failed_med_8": "",
      "failed_med_9": ""
    }
  }
}
eof
  end
end
