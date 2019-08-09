require 'spec_helper'

describe 'Access Token' do
  let(:api_id) {'ahhbrzs4a0q1om3y7nwn'}
  let(:api_secret) {'kkihcug797zu4bzomnh-sbamgqpxyr5yf2pvvqzm'}
  let(:client) { CoverMyMeds::Client.new(api_id, api_secret)}
  let(:version) { 1 }
  let (:request_id) {'NT4HJ4'}

  context 'create token' do
    before do
      stub_request(:post, "https://api.covermymeds.com/requests/tokens/?request_ids[]=#{request_id}&v=#{version}")
        .with(basic_auth: [api_id, api_secret])
        .to_return( status: 201, body: fixture('post_token.json'))
    end

    it 'returns new token' do
      token = client.create_access_token(request_id)
      expect(token['id']).to eq 'nhe44fu4g22upqqgstea'
      expect(token['request_id']).to eq request_id
    end
  end

  context 'revoke access token' do
    let(:token_id) { 'tikl5sci8q24kfy1h3rb' }
    before do
      stub_request(:delete, "https://api.covermymeds.com/requests/tokens/#{token_id}?v=#{version}")
        .with(basic_auth: [api_id, api_secret])
        .to_return( status: 201, body: fixture('post_token.json'))
    end

    it 'returns response' do
      expect(client.revoke_access_token?(token_id)).to be_truthy
    end
  end
end
