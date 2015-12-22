require 'spec_helper'

describe 'Request' do
  let(:api_id) {'ahhbrzs4a0q1om3y7nwn'}
  let(:api_secret) {'kkihcug797zu4bzomnh-sbamgqpxyr5yf2pvvqzm'}
  let(:client) { CoverMyMeds::Client.new(api_id, api_secret)}
  let(:version) { 1 }

  context 'get request' do
    let(:token_id) {'faketokenabcde1'}
    before do
      stub_request(:post, "https://#{api_id}:#{api_secret}@api.covermymeds.com/requests/search/?v=#{version}")
      .with(body: { token_ids: [token_id] })
      .to_return( status: 200, body: fixture('get_single_request.json'))
    end

    it 'returns single request' do
      request = client.get_request(token_id)
      request.tokens.first.id = token_id
      expect(request.patient.first_name).to eq'Justin'
      expect(request.patient.last_name).to eq 'Rolston'
      expect(request.patient.date_of_birth).to eq '01/01/1900'
      expect(request.prescription.drug_id).to eq '093563'
    end
  end

  context 'get multiple requests' do
    let(:token_ids) {['pbma9uxy47smi957okxo', 'npnojtoqsmf94q7d481j']}

    before do
      WebMockStrict.start

      stub_request(:post, "https://#{api_id}:#{api_secret}@api.covermymeds.com/requests/search/?token_ids[]=#{token_ids.first}&token_ids[]=#{token_ids.last}&v=#{version}")
      .to_return( status: 200, body: fixture('get_multiple_requests.json'))
    end

    it 'returns 2 requests' do
      expect(client.get_requests(token_ids).count).to eq 2
    end

    after do
      WebMockStrict.stop
    end
  end

  context 'create request' do
    let(:new_request_data) do
      request_data = client.request_data
      request_data.patient.first_name = 'Justin'
      request_data
    end

    before do
      stub_request(:post, "https://#{api_id}:#{api_secret}@api.covermymeds.com/requests/?v=#{version}")
      .to_return( status: 201, body: fixture('create_request.json'))
    end

    it 'creates request' do
      data = client.create_request new_request_data
      expect(data.id).to eq 'VA4EG7'
      expect(data.patient.first_name).to eq new_request_data.patient.first_name
    end
  end
end
