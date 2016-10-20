require 'spec_helper'

describe 'Request' do
  let(:api_id)      { 'ahhbrzs4a0q1om3y7nwn' }
  let(:client)      { CoverMyMeds::Client.new(api_id) }
  let(:version)     { 1 }
  let(:request_id)  { SecureRandom.uuid }
  let(:token_id)    { 'faketokenabcde1' }

  context 'get request page' do
    context 'without remote_user given' do
      before do
        stub_request(:get, "https://api.covermymeds.com/request-pages/#{request_id}?&v=#{version}")
        .with(
          headers: { "Authorization" => "Bearer #{api_id}+#{token_id}" }
        ).to_return( status: 200, body: fixture('get_request_page.json'))
      end

      it 'returns request page' do
        request_page = client.get_request_page(request_id, token_id)
        expected_keys = ["data", "forms", "actions", "provided_coded_references", "validations"]
        expect(request_page.keys).to match_array expected_keys
      end
    end

    context 'with remote_user given' do
      let(:remote_user) { Hash[remote_user_key, remote_user_value] }
      let(:remote_user_key) { SecureRandom.uuid }
      let(:remote_user_value) { SecureRandom.uuid }

      before do
        stub_request(:get, "https://api.covermymeds.com/request-pages/#{request_id}?&v=#{version}&remote_user[#{remote_user_key}]=#{remote_user_value}")
        .with(
          headers: { "Authorization" => "Bearer #{api_id}+#{token_id}" }
        ).to_return( status: 200, body: fixture('get_request_page.json'))
      end

      it 'sends a remote_user' do
        request_page = client.get_request_page(request_id, token_id, remote_user)
        expected_keys = ["data", "forms", "actions", "provided_coded_references", "validations"]
        expect(request_page.keys).to match_array expected_keys
      end
    end

    context 'a redirect is returned' do
      before do
        stub_request(:get, "https://www.example.com/").to_return(status: 200, body: { request_page: { data: "You redirected" } }.to_json)
        stub_request(:get, "https://api.covermymeds.com/request-pages/#{request_id}?&v=#{version}")
          .with( headers: { "Authorization" => "Bearer #{api_id}+#{token_id}" })
          .to_return( status: 302, :headers => { "Location" => "https://www.example.com/" })
      end

      it 'follows redirects' do
        request_page = client.get_request_page(request_id, token_id)
        expect(request_page.data).to eq "You redirected"
      end
    end
  end
end
