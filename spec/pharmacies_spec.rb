require 'spec_helper'

describe 'Pharmacies' do

  let(:api_id) { 'LetsDoThis' }
  let(:client) { CoverMyMeds::Client.new(api_id)}

  context '#pharmacy_search' do
    let(:params)        { { fax: fax, zip_code: zip_code, name: pharmacy_name } }
    let(:fax)           { 55555555 }
    let(:zip_code)      { 12345 }
    let(:pharmacy_name) { 'CVS' }
    let(:version)       { 1 }
    before do
      stub_request(:get, "https://#{api_id}:@api.covermymeds.com/pharmacies/?fax=#{fax}&name=#{pharmacy_name}&zip_code=#{zip_code}&v=#{version}")
      .to_return( status: 200, body: fixture('pharmacies.json'))
    end

    it 'makes methods from json' do
      pharmacies = client.pharmacy_search params
      expect(pharmacies).to be_an Array
      pharmacy = pharmacies.first
      expect(pharmacy.id).to eq 27313
      expect(pharmacy.name).to eq 'CVS PHARMACY'
      expect(pharmacy.address_1).to eq '2160 N HIGH ST'
      expect(pharmacy.address_2).to eq ''
      expect(pharmacy.city).to eq 'COLUMBUS'
      expect(pharmacy.state).to eq 'OH'
      expect(pharmacy.zip_code).to eq '43201'
      expect(pharmacy.npi).to eq '5555555555'
      expect(pharmacy.ncpdp).to eq '5555555'
    end
  end

  context '#get_pharmacy' do
    let(:npi) { '5555555555'}
    let(:version) { 1 }

    before do
      stub_request(:get, "https://#{api_id}:@api.covermymeds.com/pharmacies/#{npi}?v=#{version}")
      .to_return( status: 200, body: fixture('pharmacy.json'))
    end

    it 'makes methods from json' do
      pharmacy = client.get_pharmacy npi
      expect(pharmacy.id).to eq 116043
      expect(pharmacy.name).to eq 'CVS PHARMACY'
      expect(pharmacy.address_1).to eq '2160 N HIGH ST'
      expect(pharmacy.address_2).to eq ''
      expect(pharmacy.city).to eq 'COLUMBUS'
      expect(pharmacy.state).to eq 'OH'
      expect(pharmacy.zip_code).to eq '43201'
      expect(pharmacy.npi).to eq '5555555555'
      expect(pharmacy.ncpdp).to eq '5555555'
    end
  end
end
