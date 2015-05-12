require 'spec_helper'

describe 'Indicators' do
  junklet :api_id, :api_secret, :bin, :pcn, :group_id
  let(:version) { 1 }
  let(:uri) { "https://#{api_id}:#{api_secret}@api.covermymeds.com/indicators/?v=#{version}" }
  let(:client) { CoverMyMeds::Client.new(api_id, api_secret) }
  let(:prescription_payload) { Hash drug_id: '12345' }
  let(:payer_payload) { Hash bin: bin, pcn: pcn, group_id: group_id }
  let(:patient_payload) { { last_name: 'Doe' } }

  describe '#post_indicators' do
    before { VCR.turn_off! }
    let(:token_id) { 'faketoken' }
    let!(:api_request) do
      stub_request(:post, uri)
        .with(body: hash_including(post_data))
        .to_return({})
    end
    let(:post_data) { Hash prescription:  prescription_payload }

    it 'has prescription data in the request' do
      client.post_indicators(prescription_payload)
      expect(api_request).to have_been_requested
    end

    context 'when given patient data' do
      let(:post_data) { Hash prescription: prescription_payload, patient: patient_payload, payer: {} }
      it 'has patient data in the request' do
        client.post_indicators(prescription_payload, patient_payload)
        expect(api_request).to have_been_requested
      end
    end

    context 'when given payer data' do
      let(:post_data) { Hash prescription: prescription_payload, patient:  {}, payer: payer_payload }
      it 'has payer data in the request' do
        client.post_indicators(prescription_payload, {}, payer_payload)
        expect(api_request).to have_been_requested
      end
    end

    context 'when additional data is included in the response body' do 
      #response from indicators API
      let(:extra_data) { Hash pa_required: true, autostart: true }
      let(:prescription_response) { prescription_payload.merge(extra_data) }
      let(:post_data) { Hash prescription: prescription_payload, patient:  {}, payer: {} }

      before do
        stub_request(:post, uri)
          .with(body: hash_including(post_data))
          .to_return(status: 200, body: { prescription: prescription_response }.to_json)
      end

      it 'includes the additional data' do
        prediction = client.post_indicators(prescription_payload)
        extra_data.each do |method_name,value|
          expect(prediction.prescription.send(method_name)).to eq(value)
        end
      end
    end
  end
end
