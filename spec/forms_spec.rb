require 'spec_helper'

describe 'Forms' do
  let(:api_id) {'LetsDoThis' }
  let(:client) { CoverMyMeds::Client.new(api_id) }
  let(:version){ 1 }

  context 'search' do
    let(:drug_id) { '093563' }
    let(:form)    {'anthem'}
    let(:state)   {'oh'}
    let(:drug)    {'Boniva'}
    let(:version) { 1 }

    before do
      stub_request(:get, "https://#{api_id}:@api.covermymeds.com/forms/?drug_id=#{drug_id}&state=#{state}&q=#{form}&v=#{version}")
      .to_return(status: 200, body: fixture('forms.json'))
    end

    it 'returns matching forms' do
      forms = client.form_search(form, drug_id, state)
      single_form = forms.first
      expect(single_form.id).to               eq 15257
      expect(single_form.href).to             eq 'https://staging.api.covermymeds.com/forms/15257'
      expect(single_form.name).to             eq 'blue_cross_blue_shield_georgia_general'
      expect(single_form.description).to      eq 'Anthem Non-Preferred Medications Request Form'
      expect(single_form.directions).to       eq 'Anthem Prior Authorization Form for Non-Preferred Medications Request '
      expect(single_form.request_form_id).to  eq 'blue_cross_blue_shield_georgia_general_15257'
      expect(single_form.thumbnail_url).to    eq 'https://navinet.covermymeds.com/forms/pdf/thumbs/90/blue_cross_blue_shield_georgia_general_15257.jpg'
    end
  end

  context 'get' do
    let(:form_id) { 'humana_tracleer_4' }
    let(:version) { 1 }

    before do
      stub_request(:get, "https://#{api_id}:@api.covermymeds.com/forms/humana_tracleer_4?v=#{version}")
      .to_return(status: 200, body: fixture('form.json'))
    end

    it 'returns matching forms' do
      form = client.get_form(form_id)
      expect(form.id).to              eq 4
      expect(form.href).to            eq 'https://api.covermymeds.com/forms/4'
      expect(form.name).to            eq 'humana_tracleer'
      expect(form.description).to     eq 'Humana Tracleer form'
      expect(form.directions).to      eq 'Humana Clinical Pharmacy Review Form for Tracleer'
      expect(form.request_form_id).to eq 'humana_tracleer_4'
      expect(form.thumbnail_url).to   eq 'https://www.covermymeds.com/forms/pdf/thumbs/90/humana_tracleer_4.jpg'
      expect(form.is_epa).to          eq false
      expect(form.contact_name).to    eq 'Humana'
      expect(form.contact_phone).to   eq '(800) 555-2546'
      expect(form.contact_fax).to     eq '(877) 486-2621'
    end
  end
end
