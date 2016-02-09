require "spec_helper"

module CoverMyMeds
  module Error
    describe HTTPError do

      subject { described_class.new status, error_json, http_method, rest_resource }

      specify "#message" do
        expect(subject.message).to eq(
          "#{status}: #{error_json}\n"+
          "in response to:\n"+
          "#{http_method.upcase} #{rest_resource}\n"
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

      specify "#rest_resource" do
        expect(subject.rest_resource).to eq(rest_resource)
      end

      let(:status) { 404 }

      let(:error_json) do
        Hash[errors: [{ debug: "Nothing to see here, move along." }]].to_json
      end

      let(:http_method) { 'post' }

      let(:rest_resource) { 'https://<url>/<route>/?<params>&v=<version>' }

    end
  end
end
