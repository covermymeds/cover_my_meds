require "spec_helper"

module CoverMyMeds
  module Error
    describe HTTPError do

      subject { described_class.new status, error_json }

      specify "#message" do
        expect(subject.message).to eq("#{status}: #{error_json}")
      end

      specify "#status" do
        expect(subject.status).to eq(status)
      end

      specify "#error_json" do
        expect(subject.error_json).to eq(error_json)
      end

      let(:status) { 404 }

      let(:error_json) do
        Hash[errors: [{ debug: "Nothing to see here, move along." }]].to_json
      end

    end
  end
end
