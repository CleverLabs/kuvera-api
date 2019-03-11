# frozen_string_literal: true

RSpec.describe Kuvera::Api do
  let(:client) { instance_double(Kuvera::Api::Client) }
  let(:address) { '0x1234abcd' }
  let(:response) { :response }

  it 'delegates `at` to Client' do
    expect(Kuvera::Api::Client).to receive(:new).and_return(client)
    expect(client).to receive(:at).with(address).and_return(response)

    expect(described_class.at(address)).to eql(response)
  end
end
