require 'spec_helper'

describe 'Drugs' do

  let(:api_id) {'LetsDoThis'}
  let(:client) { CoverMyMeds::Client.new(api_id)}

  context 'search' do
    let(:drug)    {'Boniva'}
    let(:version) { 1 }
    before do
      stub_request(:get, "https://api.covermymeds.com/drugs/?q=#{drug}&v=#{version}")
        .with(basic_auth: [api_id, ''])
        .to_return( status: 200, body: fixture('drugs.json'))
    end

    it 'makes methods from json' do
      drugs = client.drug_search drug
      expect(drugs).to be_a Array
      single_drug = drugs.first
      expect(single_drug.id).to eq                        '093563'
      expect(single_drug.name).to eq                      'Boniva'
      expect(single_drug.gpi).to eq                       '30042048100360'
      expect(single_drug.sort_group).to                   be_nil
      expect(single_drug.sort_order).to                   be_nil
      expect(single_drug.route_of_administration).to eq   'OR'
      expect(single_drug.dosage_form).to eq               'TABS'
      expect(single_drug.strength).to eq                  '150'
      expect(single_drug.strength_unit_of_measure).to eq  'MG'
      expect(single_drug.full_name).to eq                 'Boniva 150MG tablets'
      expect(single_drug.href).to eq                      'https://staging.api.covermymeds.com/drugs/093563'
    end
  end

  context 'get_drug' do
    let(:drug_id) { '001002'}
    let(:version) { 1 }

    before do
      stub_request(:get, "https://api.covermymeds.com/drugs/#{drug_id}?v=#{version}")
        .with(basic_auth: [api_id, ''])
        .to_return( status: 200, body: fixture('drug.json'))
    end

    it 'makes methods from json' do
      drug = client.get_drug drug_id
      expect(drug.id).to        eq '001002'
      expect(drug.full_name).to eq 'Ambien 10MG tablets'
    end
  end
end
