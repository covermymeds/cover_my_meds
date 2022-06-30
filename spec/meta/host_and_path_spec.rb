module CoverMyMeds::ExampleApiResources
  include CoverMyMeds::HostAndPath
  include CoverMyMeds::ApiRequest
end

class AnyClass
  include CoverMyMeds::ExampleApiResources
  def default_host
    "http://default-host.com"
  end
end

describe AnyClass do

  it "has an added path getter" do
    expect(subject.example_api_resources_path).to eq("/example-api-resources/")
  end

  it "has an added host getter" do
    expect(subject.example_api_resources_host).to eq("http://default-host.com")
  end

  describe "the added path setter" do
    it "changes the example_api_resources_path" do
      subject.example_api_resources_path = "mypath"
      expect(subject.example_api_resources_path).to eq("mypath")
    end
  end

  describe "the added host setter" do
    it "changes the example_api_resources_host" do
      subject.example_api_resources_host = "myhost"
      expect(subject.example_api_resources_host).to eq("myhost")
    end
  end

  describe "the added resource-partially-applied method for web requests" do
    it "should proxy for #request" do
      expect(subject).to receive(:request).with(:GET, "http://default-host.com", "/example-api-resources/", {v: 1})
      subject.example_api_resources_request(:GET, params: {v: 1})
    end

    context "when the path is a Fixnum" do
      let(:path) { junk :int }
      it "does not blow up" do
        stub_request :get, %r{example-api-resources/#{path}}
        expect { subject.example_api_resources_request(:get, path: path) }.to_not raise_error
      end
    end
  end

end
