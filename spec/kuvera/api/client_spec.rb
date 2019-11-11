# frozen_string_literal: true

RSpec.describe Kuvera::Api::Client do
  subject { described_class.new }

  let(:body) { { 'secret' => 'value' }.to_json }
  let(:address) { '0x1234abcd' }
  let(:response) { instance_double(Net::HTTPOK, code: '200', body: body) }
  let(:processor) { ->(_) { :value } }

  describe '::RESPONSES' do
    it 'can process 200 response code' do
      expect(described_class::RESPONSES[200].call(response)).to eql('value')
    end

    it 'can process 403 response code' do
      expect do
        described_class::RESPONSES[403].call(response)
      end.to raise_error(Kuvera::Api::SecretAlreadyRead)
    end

    it 'can process 404 response code' do
      expect do
        described_class::RESPONSES[404].call(response)
      end.to raise_error(Kuvera::Api::SecretNotFound)
    end
  end

  describe '#at' do
    before do
      stub_const('Kuvera::Api::Client::RESPONSES', 200 => processor)
    end

    it 'calls Kuvera server and processes response' do
      expect(Net::HTTP).to receive(:get_response).and_return(response)
      expect(subject.at(address)).to eql(:value)
    end
  end

  context 'oauth-related code' do
    subject { described_class.new(host: host, uid: uid, secret: secret) }

    let(:host) { 'host' }
    let(:uid) { 'uid' }
    let(:secret) { 'secret' }
    let(:oauth) { instance_double(Kuvera::Api::Oauth) }

    before do
      expect(Kuvera::Api::Oauth).to receive(:new).and_return(oauth)
    end

    describe '#me' do
      it 'calls Kuvera /me though the OAuth client' do
        expect(oauth).to receive(:get).with(Kuvera::Api::Client::ME_ENDPOINT)
        subject.me
      end
    end

    describe '#upload' do
      let(:file) { instance_double(File, path: '/path/file.pdf') }
      let(:upload) { instance_double(Faraday::UploadIO) }
      let(:title) { 'title' }
      let(:mime) { 'mime' }

      it 'wraps file and sent to Kuvera though the OAuth client' do
        expect(Faraday::UploadIO).to receive(:new)
          .with(file, mime, 'file.pdf')
          .and_return(upload)
        expect(oauth).to receive(:post).with(
          Kuvera::Api::Client::UPLOAD_ENDPOINT,
          {
            new_secret: {
              type: 'SecretAttachment',
              title: title,
              body: upload
            }
          },
          headers: {}
        )
        subject.upload(title, file, mime)
      end
    end

    describe '#share' do
      let(:address) { '0x1234abcd' }

      it 'calls Kuvera /api/v1/secrets though the OAuth client' do
        expect(oauth).to receive(:post).with(
          Kuvera::Api::Client::SHARE_ENDPOINT, '{"secret_id":"0x1234abcd"}'
        )
        subject.share(address)
      end
    end
  end
end
