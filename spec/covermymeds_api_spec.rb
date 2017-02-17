require 'spec_helper'

describe CoverMyMeds do
  it 'has a version number' do
    expect(CoverMyMeds::VERSION).not_to be nil
  end

  describe 'supports RESTful methods' do
    it 'has a GET constant' do
      expect(CoverMyMeds::GET).to eq 'get'
    end

    it 'has a POST constant' do
      expect(CoverMyMeds::POST).to eq 'post'
    end

    it 'has a PUT constant' do
      expect(CoverMyMeds::PUT).to eq 'put'
    end

    it 'has a PATCH constant' do
      expect(CoverMyMeds::PATCH).to eq 'patch'
    end

    it 'has a DELETE constant' do
      expect(CoverMyMeds::DELETE).to eq 'delete'
    end
  end
end
