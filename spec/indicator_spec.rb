require 'spec_helper'

describe 'Indicators' do
  junklet :api_id, :api_secret, :bin, :pcn, :group_id
  let(:version) { 1 }
  let(:uri) { "https://api.covermymeds.com/indicators/?v=#{version}" }
  let(:client) { CoverMyMeds::Client.new(api_id, api_secret) }
  let(:prescription_payload) { Hash drug_id: '12345' }
  let(:payer_payload) { Hash bin: bin, pcn: pcn, group_id: group_id }
  let(:patient_payload) { { last_name: 'Doe' } }
  let(:prescriber_payload) { Hash npi: '1234567890' }

  describe '#post_indicators' do
    let(:token_id) { 'faketoken' }
    let!(:api_request) do
      stub_request(:post, uri)
        .with(body: hash_including(post_data), basic_auth: [api_id, api_secret])
        .to_return({})
    end
    let(:post_data) { Hash prescription:  prescription_payload }

    context 'when patient data is missing' do
      it 'raises an error' do
        expect { client.post_indicators(prescription: prescription_payload) }.to raise_error(NameError)
      end
    end

    context 'when prescriber data is missing' do
      it 'raises an error' do
        expect { client.post_indicators(patient: patient_payload) }.to raise_error(NameError)
      end
    end

    context 'when given prescription and patient data' do
      let(:post_data) { Hash prescription: prescription_payload, patient: patient_payload, payer: {} }
      it 'has patient data in the request' do
        client.post_indicators(prescription: prescription_payload, patient: patient_payload)
        expect(api_request).to have_been_requested
      end
    end

    context 'when given prescription, patient, and payer data' do
      let(:post_data) { Hash prescription: prescription_payload, patient: patient_payload, payer: payer_payload }
      it 'has payer data in the request' do
        client.post_indicators(prescription: prescription_payload, patient: patient_payload, payer: payer_payload)
        expect(api_request).to have_been_requested
      end
    end

    context 'when given prescription, prescriber, patient, and payer data' do
      let(:post_data) { Hash prescription: prescription_payload, patient: patient_payload, payer: payer_payload, prescriber: prescriber_payload }
      it 'has payer data in the request' do
        client.post_indicators(prescription: prescription_payload, patient: patient_payload, payer: payer_payload, prescriber: prescriber_payload)
        expect(api_request).to have_been_requested
      end
    end

    context 'when additional data is included in the response body' do
      #response from indicators API
      let(:extra_data) { Hash pa_required: true, autostart: true }
      let(:prescription_response) { prescription_payload.merge(extra_data) }
      let(:post_data) { Hash prescription: prescription_payload, patient: patient_payload, payer: {} }

      before do
        stub_request(:post, uri)
          .with(body: hash_including(post_data), basic_auth: [api_id, api_secret])
          .to_return(status: 200, body: { prescription: prescription_response }.to_json)
      end

      it 'includes the additional data' do
        prediction = client.post_indicators(prescription: prescription_payload, patient: patient_payload)
        extra_data.each do |method_name,value|
          expect(prediction.prescription.send(method_name)).to eq(value)
        end
      end
    end
  end

  describe '#search_indicators' do
    let(:uri) { "https://api.covermymeds.com/indicators/search/?v=#{version}" }
    let(:token_id) { 'faketoken' }
    let!(:api_request) do
      stub_request(:post, uri)
        .with(body: hash_including(post_data), basic_auth: [api_id, api_secret])
        .to_return({})
    end
    let(:post_data) { Hash prescriptions:  prescription_payload }
    let(:prescription_payload) { [{drug_id: '12345'}, {drug_id: '98765'}] }

    it 'has prescription data in the request' do
      client.search_indicators(prescriptions: prescription_payload)
      expect(api_request).to have_been_requested
    end

    context 'when prescription data is missing' do
      it 'raises an error' do
        expect { client.search_indicators() }.to raise_error(NameError)
      end
    end

    context 'when given prescription and patient data' do
      let(:post_data) { Hash prescriptions: prescription_payload, patient: patient_payload, payer: {} }
      it 'has patient data in the request' do
        client.search_indicators(prescriptions: prescription_payload, patient: patient_payload)
        expect(api_request).to have_been_requested
      end
    end

    context 'when given prescription and payer data' do
      let(:post_data) { Hash prescriptions: prescription_payload, patient:  {}, payer: payer_payload }
      it 'has payer data in the request' do
        client.search_indicators(prescriptions: prescription_payload, patient: {}, payer: payer_payload)
        expect(api_request).to have_been_requested
      end
    end

    context 'when additional data is included in the response body' do
      #response from indicators API
      let(:extra_data) { Hash pa_required: true, autostart: true }
      let(:prescription_response) { prescription_payload.map{ |p| p.merge(extra_data)} }
      let(:post_data) { Hash prescriptions: prescription_payload, patient:  {}, payer: {} }

      before do
        stub_request(:post, uri)
          .with(body: hash_including(post_data), basic_auth: [api_id, api_secret])
          .to_return(status: 200, body: { prescriptions: prescription_response }.to_json)
      end

      it 'includes the additional data' do
        prediction = client.search_indicators(prescriptions: prescription_payload)
        extra_data.each do |method_name,value|
          prediction.prescriptions.each do |p|
            expect(p.send(method_name)).to eq(value)
          end
        end
      end
    end
  end
end
