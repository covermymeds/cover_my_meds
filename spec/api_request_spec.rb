require 'spec_helper'

describe 'Request' do
  let(:api_id)            { 'ahhbrzs4a0q1om3y7nwn' }
  let(:api_secret)        { 'kkihcug797zu4bzomnh-sbamgqpxyr5yf2pvvqzm' }
  let(:scheme)            { 'https://' }
  let(:host)              { 'api.covermymeds.com' }
  let(:path)              { '/errors' }
  let(:json_response)     { '{ "test": "response" }' }
  let(:parsed_json)       { JSON.parse(json_response) }
  let(:non_json_response) { 'This is not JSON' }

  let(:client) do
    h, p = "#{scheme}#{host}", path
    CoverMyMeds::Client.new(api_id, api_secret) do |c|
      c.define_singleton_method :get_error do
        request(:get, h, p)
      end
    end
  end

  context 'get request with error' do
    before do
      stub_request(:get, "#{scheme}#{host}#{path}").with(basic_auth: [api_id, api_secret])
      .to_return(status: 400, body: fixture('api_client_error.json'))
    end

    it 'returns single request' do
      expect { client.get_error }.to raise_error(CoverMyMeds::Error::HTTPError)
    end
  end

  context 'get request' do
    context 'non-json response' do
      before do
        stub_request(:get, "#{scheme}#{host}#{path}").with(basic_auth: [api_id, api_secret])
        .to_return(status: 200, body: non_json_response)
      end

      it "returns the response body if it can't be JSON parsed" do
        expect(client.request(:get, "#{scheme}#{host}", path)).to eq(non_json_response)
      end
    end

    context 'json response' do
      before do
        stub_request(:get, "#{scheme}#{host}#{path}").with(basic_auth: [api_id, api_secret])
        .to_return(status: 200, body: json_response)
      end

      it "returns the parsed response body" do
        expect(client.request(:get, "#{scheme}#{host}", path)).to eq(parsed_json)
      end
    end
  end

end
