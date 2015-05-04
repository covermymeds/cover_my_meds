module CoverMyMeds::ExampleApiResources
  include CoverMyMeds::HostAndPath
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

  describe "the added resouce-partially-applied method for web requests" do
    it "should proxy for #request" do
      expect(subject).to receive(:request).with(:GET, "http://default-host.com", "/example-api-resources/", {v: 1})
      subject.example_api_resources_request(:GET, params: {v: 1})
    end
  end

end
