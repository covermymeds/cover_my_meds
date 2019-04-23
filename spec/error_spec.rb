require "spec_helper"

module CoverMyMeds
  module Error
    describe HTTPError do

      subject { described_class.new status, error_json, http_method, url }

      specify "#message" do
        expect(subject.message).to eq(<<-EOS
404: {"errors":[{"debug":"Nothing to see here, move along."}]}
in response to:
POST https://<url>/<route>/?<params>&v=<version>
        EOS
        )
      end

      specify "#status" do
        expect(subject.status).to eq(status)
      end

      specify "#error_json" do
        expect(subject.error_json).to eq(error_json)
      end

      specify "#http_method" do
        expect(subject.http_method).to eq(http_method)
      end

      specify "#url" do
        expect(subject.url).to eq(url)
      end

      let(:status) { 404 }

      let(:error_json) do
        Hash[errors: [{ debug: "Nothing to see here, move along." }]].to_json
      end

      let(:http_method) { 'post' }

      let(:url) { 'https://<url>/<route>/?<params>&v=<version>' }
    end
  end
end
