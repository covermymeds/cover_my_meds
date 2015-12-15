require 'spec_helper'

describe 'Consumer' do
  let(:api_id) { 'ahhbrzs4a0q1om3y7nwn' }
  let(:api_secret) { 'kkihcug797zu4bzomnh-sbamgqpxyr5yf2pvvqzm' }
  let(:client) { CoverMyMeds::Client.new(api_id, api_secret) }
  let(:version) { 1 }
  let(:email) { "#{junk}@example.cool" }
  junklet :description
  let(:params) { Hash email: email, description: description }
  let(:response) do
    {
      consumer: {
        api_id: junk,
        secret: junk,
        email: email,
        description: description
      }
    }
  end
  let!(:consumer_create_stub) do
    stub_request(
      :post,
      %r{
        https://#{api_id}:#{api_secret}@api\.covermymeds\.com/consumers/\?
        (?=.*v=#{version})
        (?=.*description=#{description})
        (?=.*email=#{email})
      }x
    ).to_return(body: response.to_json)
  end

  context 'create consumer' do
    it 'sends a post to the consumers endpoint' do
      client.create_consumer(params)
      expect(consumer_create_stub).to have_been_requested
    end
  end
end
