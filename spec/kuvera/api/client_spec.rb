# frozen_string_literal: true

RSpec.describe Kuvera::Api::Client do
  subject { described_class.new }

  let(:body) { { "secret" => "value" }.to_json }
  let(:address) { '0x1234abcd' }
  let(:response) { instance_double(Net::HTTPOK, code: "200", body: body) }
  let(:processor) { ->(_) { :value  } }

  describe '::RESPONSES' do
    it 'can process 200 response code' do
      expect(described_class::RESPONSES[200].call(response)).to eql("value")
    end

    it 'can process 403 response code' do
      expect {
        described_class::RESPONSES[403].call(response)
      }.to raise_error(Kuvera::Api::SecretAlreadyRead)
    end

    it 'can process 404 response code' do
      expect {
        described_class::RESPONSES[404].call(response)
      }.to raise_error(Kuvera::Api::SecretNotFound)
    end
  end

  describe '#at' do
    before do
      stub_const("Kuvera::Api::Client::RESPONSES", { 200 => processor })
    end

    it 'calls Kuvera server and processes response' do
      expect(Net::HTTP).to receive(:get_response).and_return(response)
      expect(subject.at(address)).to eql(:value)
    end
  end
end
