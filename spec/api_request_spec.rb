require 'spec_helper'

describe 'Request' do
  let(:api_id)     { 'ahhbrzs4a0q1om3y7nwn' }
  let(:api_secret) { 'kkihcug797zu4bzomnh-sbamgqpxyr5yf2pvvqzm' }
  let(:scheme)     { 'https://' }
  let(:host)       { 'api.covermymeds.com' }
  let(:path)       { '/errors' }

  let(:client) do
    h, p = "#{scheme}#{host}", path
    CoverMyMeds::Client.new(api_id, api_secret) do |c|
      c.define_singleton_method :get_error do
        request(:get, h, p)
      end
    end
  end

  context 'get request' do
    before do
      stub_request(:get, "#{scheme}#{api_id}:#{api_secret}@#{host}#{path}")
      .to_return(status: 400, body: fixture('api_client_error.json'))
    end

    it 'returns single request' do
      expect { client.get_error }.to raise_error(CoverMyMeds::Error::HTTPError)
    end
  end

end
