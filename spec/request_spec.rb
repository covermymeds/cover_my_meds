require 'spec_helper'

describe 'Request' do
  let(:api_id) {'ahhbrzs4a0q1om3y7nwn'}
  let(:api_secret) {'kkihcug797zu4bzomnh-sbamgqpxyr5yf2pvvqzm'}
  let(:client) { CoverMyMeds::Client.new(api_id, api_secret)}
  let(:version) { 1 }

  junklet :from_fax, :office_fax, :request_id, :token_id

  describe 'get request' do
    let(:token_id) {'faketokenabcde1'}
    before do
      stub_request(:post, "https://api.covermymeds.com/requests/search/?v=#{version}")
      .with(body: { token_ids: [token_id] }, basic_auth: [api_id, api_secret])
      .to_return( status: 200, body: fixture('get_single_request.json'))
    end

    it 'returns single request' do
      request = client.get_request(token_id)
      request['tokens'].first['id'] = token_id
      expect(request['patient']['first_name']).to eq'Justin'
      expect(request['patient']['last_name']).to eq 'Rolston'
      expect(request['patient']['date_of_birth']).to eq '01/01/1900'
      expect(request['prescription']['drug_id']).to eq '093563'
    end
  end

  describe 'get multiple requests' do
    let(:token_ids) {['pbma9uxy47smi957okxo', 'npnojtoqsmf94q7d481j']}

    before do
      WebMockStrict.start

      stub_request(:post, "https://api.covermymeds.com/requests/search/?token_ids[]=#{token_ids.first}&token_ids[]=#{token_ids.last}&v=#{version}")
      .with(basic_auth: [api_id, api_secret])
      .to_return( status: 200, body: fixture('get_multiple_requests.json'))
    end

    it 'returns 2 requests' do
      expect(client.get_requests(token_ids).count).to eq 2
    end

    after do
      WebMockStrict.stop
    end
  end

  describe 'create request' do
    let(:new_request_data) do
      request_data = client.request_data
      request_data['patient']['first_name'] = 'Justin'
      request_data
    end

    before do
      stub_request(:post, "https://api.covermymeds.com/requests/?v=#{version}")
      .with(basic_auth: [api_id, api_secret])
      .to_return( status: 201, body: fixture('create_request.json'))
    end

    it 'creates request' do
      data = client.create_request new_request_data
      expect(data['id']).to eq 'VA4EG7'
      expect(data['patient']['first_name']).to eq new_request_data['patient']['first_name']
    end
  end

  describe 'send to plan' do
    let!(:api_stub) do
      stub_request(:post, "https://api.covermymeds.com/requests/#{request_id}/send_to_plan")
        .with(query: { v: version })
        .with(body: fax_params, headers: { 'Authorization' => "Bearer #{api_id}+#{token_id}" })
        .to_return(status: 200, body: { request: { id: request_id } }.to_json)
    end

    context "with all required params" do
      let!(:pa_request) do
        client.send_to_plan_request request_id, token_id, fax_params
      end

      let(:fax_params) { Hash office_fax: office_fax, from_fax: from_fax }

      it "sends the request" do
        expect(api_stub).to have_been_requested
      end

      it "returns an object with the data" do
        expect(pa_request['id']).to eq request_id
      end
    end

    context "without office fax" do
      let(:fax_params) { Hash from_fax: from_fax }

      it "raises an error" do
        expect {
          client.send_to_plan_request request_id, token_id, fax_params
        }.to raise_error ArgumentError, /office_fax/
      end
    end

    context "without from fax" do
      let(:fax_params) { Hash office_fax: office_fax }

      it "raises an error" do
        expect {
          client.send_to_plan_request request_id, token_id, fax_params
        }.to raise_error ArgumentError, /from_fax/
      end
    end
  end

  describe 'archive request' do
    let(:archive_params) do
      {
        outcome: "favorable",
      }
    end

    let!(:api_stub) do
      stub_request(:post, "https://api.covermymeds.com/requests/#{request_id}/archive")
        .with(query: { v: version })
        .with(body: archive_params, headers: { 'Authorization' => "Bearer #{api_id}+#{token_id}" })
        .to_return(status: 200, body: { request: { id: request_id } }.to_json)
    end

    it "sends the request" do
      data = client.archive_request request_id, token_id, archive_params
      expect(data['id']).to eq(request_id)
    end
  end
end
