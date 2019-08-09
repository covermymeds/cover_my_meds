require 'spec_helper'

describe 'Credential' do
  let(:api_id)        { 'ahhbrzs4a0q1om3y7nwn' }
  let(:api_secret)    { 'kkihcug797zu4bzomnh-sbamgqpxyr5yf2pvvqzm' }
  let(:client)        { CoverMyMeds::Client.new(api_id, api_secret) }
  let(:version)       { 1 }
  let(:npi)           { '1234567890' }
  let(:fax_number)    { '15552224444' }
  let(:email)         { 'ehrsystem@foo.dev' }
  let(:api_url)       { "https://api.covermymeds.com/prescribers/credentials/?v=#{version}" }
  let(:callback_url)  { 'https://foo.dev/callback' }
  let(:callback_verb) { 'POST' }
  let(:contact_hint) do
    {
      email:           'charles@foo.dev',
      full_name:       'Dr. Charles McFoo',
      practice: {
        name:          'McFoo Medical Clinic',
        phone_number:  '1 555 555-5555',
        address: {
          street_1:    '123 Main Street',
          street_2:    '',
          city:        'Columbus',
          state:       'OH',
          zip:         '43210'
        }
      }
    }
  end

  let(:credential_body) do
    {
      credential: {
        npi:               npi,
        callback_url:      callback_url,
        callback_verb:     callback_verb,
        fax_numbers:       [fax_number],
        contact_hint:      contact_hint
      }
    }
  end

  describe '#create_credential' do
    before do
      stub_request(:post, api_url)
      .with(
        basic_auth: [api_id, api_secret],
        body: credential_body,
      )
      .to_return( status: 201, body: fixture('post_credential.json'))
    end

    let!(:credential) { client.create_credential(npi: npi, callback_url: callback_url, callback_verb: callback_verb, fax_numbers: [fax_number], contact_hint: contact_hint) }

    it 'has the NPI' do
      expect(credential['npi']).to eq(npi)
    end

    it 'has an array of fax numbers' do
      expect(credential['fax_numbers']).to eq([fax_number])
    end

    it 'has the contact hint' do
      expect(credential["contact_hint"]["email"]).to eq('charles@foo.dev')
      expect(credential["contact_hint"]["practice"]["name"]).to eq('McFoo Medical Clinic')
      expect(credential["contact_hint"]["practice"]["address"]["city"]).to eq('Columbus')
    end
  end

  describe '#delete_credential' do
    let(:api_url)                 { "https://api.covermymeds.com/prescribers/credentials/#{npi}" }
    let!(:delete_credential_stub) { stub_request(:delete, api_url).with(query: { v: version }).to_return(status: 204) }

    it 'deletes the credential' do
      client.delete_credential(npi)
      expect(delete_credential_stub).to have_been_requested
    end
  end
end
