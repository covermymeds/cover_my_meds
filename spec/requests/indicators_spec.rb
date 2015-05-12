require 'spec_helper'

describe 'Indicators API', integration: true do
  let(:version) { 1 }
  let(:api_id) { ENV['CMM_API_KEY'] }
  let(:api_secret) { ENV['CMM_API_SECRET'] }
  let(:client) do
    CoverMyMeds::Client.new(api_id, api_secret) do |c|
      c.default_host = ENV['CMM_API_URL']
    end
  end

  it 'works', vcr: true do
    response = client.post_indicators({ drug_id: '183156' })
    expect(response.prescription.drug_id).to eq('183156')
  end
end
