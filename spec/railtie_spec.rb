require 'spec_helper'

# Gotta do this manually because Rails (probably) wasn't defined the first time
# we loaded spec_helper (and thereby the rest of the gem)
require 'rails/railtie'
require 'covermymeds_api/railtie'

# We've also gotta load this because something assumes ActiveSupport is around
# for JSON serialization once we've defined Rails, which is silly, but it's the
# only way I can keep the entire suite from failing randomly with
# "uninitialized constant ActiveSupport::JSON"
require 'active_support'

describe CoverMyMeds::Railtie do
  subject { CoverMyMeds::Railtie.instance }

  describe 'default config' do
    subject { CoverMyMeds::Railtie.config.covermymeds_api }

    it { is_expected.to eq default_host: 'https://api.covermymeds.com/' }
  end

  describe '#default_client' do
    before do
      # We need to stub this out because it checks some Rails stuff that isn't
      # defined in this limited Rails scope (Rails.application.secrets), and
      # known non-nil values are useful for tests
      expect(subject).to receive(:credentials).and_return(['id','key'])
    end

    it 'delegates to #configured_client with the default credentials' do
      expect(subject).to receive(:configured_client).with 'id', 'key'
      subject.default_client
    end

    it 'caches the default client' do
      expect(subject.default_client)
        .to be CoverMyMeds::Railtie.instance.default_client
    end
  end

  describe '#configured_client' do
    before do
      subject.configure do
        config.covermymeds_api.default_host = "https://test.local"
        config.covermymeds_api.indicators_host = "http://localhost:3000"
      end
    end

    let :client do
      subject.configured_client 'key', 'secret'
    end

    it 'creates a client with the given credentials' do
      expect(client).to be_a CoverMyMeds::Client
      expect(client.instance_variable_get :@username).to eq 'key'
      expect(client.instance_variable_get :@password).to eq 'secret'
    end

    it 'configures the client based on the config object' do
      expect(client.default_host).to eq 'https://test.local'
      expect(client.indicators_host).to eq 'http://localhost:3000'
    end
  end
end

describe CoverMyMeds do
  it 'delegates default_client to the Railtie when defined' do
    expect(CoverMyMeds::Railtie.instance).to receive(:default_client)
    CoverMyMeds.default_client
  end
end
