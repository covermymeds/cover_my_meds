require 'spec_helper'

module CoverMyMeds::ExampleApiResources
  include CoverMyMeds::HostAndPath
  CURRENT_VERSION = 'current-version-1'
end

class CoverMyMeds::Client
  include CoverMyMeds::ExampleApiResources
end

describe CoverMyMeds::Client do
  let(:username) { "any_api_id" }

  describe "#new" do

    context "configuring with a block" do
      it "sets the host and path for the resource" do
        client = CoverMyMeds::Client.new(username) do |c|
          c.example_api_resources_path = "/example/resouce/path/"
          c.example_api_resources_host = "https://www.example-resource.com"
        end

        expect(client.example_api_resources_path).to eq("/example/resouce/path/")
        expect(client.example_api_resources_host).to eq("https://www.example-resource.com")
      end

      it "sets the default host" do
        client = CoverMyMeds::Client.new(username) do |c|
          c.default_host = "www.example.com"
        end

        expect(client.default_host).to eq("www.example.com")
      end
    end

    context "NOT configuring with a block" do
      it "uses the default host and path for resources" do
        client = CoverMyMeds::Client.new(username)

        expect(client.example_api_resources_path).to eq("/example-api-resources/")
        expect(client.example_api_resources_host).to eq("https://api.covermymeds.com")
      end
    end

  end

  specify "#default_host" do
    client = CoverMyMeds::Client.new(username)
    expect(client.default_host).to eq("https://api.covermymeds.com")
  end

  describe '#disable_hashie_log' do
    it 'sets the Hashie logger' do
      client = CoverMyMeds::Client.new(username)
      client.disable_hashie_log
      expect(Hashie.logger.instance_variable_get(:@logdev).filename).to eq('/dev/null')
    end
  end
end
