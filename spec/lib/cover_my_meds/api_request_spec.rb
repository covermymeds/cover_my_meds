require 'spec_helper'

class TestClass
  include CoverMyMeds::ApiRequest
end

RSpec.describe CoverMyMeds::ApiRequest do
  subject { TestClass.new }
  let(:host) { 'https://www.example.com' }
  let(:path) { '/very_important_path' }
  let(:params) { Hash(v: 1, key1: 'value1', key2: 'value2') }

  describe '#url' do
    it 'is the url constructed from the host and path' do
      expect(subject.url(host, path, {})).to eq 'https://www.example.com/very_important_path'
    end

    context 'when there are query params' do
      it 'includes the params, listed in alphabetical order' do
        expect(subject.url(host, path, params)).to eq 'https://www.example.com/very_important_path?key1=value1&key2=value2&v=1'
      end
    end
  end
end
