# frozen_string_literal: true

require 'json'
require 'net/http'

require 'kuvera/api/errors'
require 'kuvera/api/oauth'

module Kuvera
  module Api
    class Client
      HOST = 'https://kuvera.io/'
      ENV_UID = ENV['OAUTH_UID']
      ENV_SECRET = ENV['OAUTH_SECRET']
      ENV_HOST = ENV.fetch('KUVERA_API', HOST)

      AT_ENDPOINT = 'at/'
      ME_ENDPOINT = '/api/v1/me'
      UPLOAD_ENDPOINT = '/api/v1/secrets'
      SHARE_ENDPOINT = '/api/v1/links'

      ROOT = 'secret'
      ATTACHMENT = 'SecretAttachment'

      def initialize(host: ENV_HOST, uid: ENV_UID, secret: ENV_SECRET)
        @host = host
        @uid = uid
        @secret = secret
      end

      RESPONSES = {
        200 => ->(response) { JSON.parse(response.body).fetch(ROOT) },
        403 => ->(_response) { raise SecretAlreadyRead },
        404 => ->(_response) { raise SecretNotFound }
      }.freeze

      def at(address)
        response = Net::HTTP.get_response(URI.join(@host, AT_ENDPOINT, address))
        RESPONSES.fetch(response.code.to_i).call(response)
      end

      def me
        oauth.get(ME_ENDPOINT)
      end

      def upload(title, io, mime)
        upload = Faraday::UploadIO.new(io, mime, io.path.split('/').last)
        body = { new_secret: { type: ATTACHMENT, title: title, body: upload } }
        oauth.post(UPLOAD_ENDPOINT, body, headers: {})
      end

      def share(address)
        oauth.post(SHARE_ENDPOINT, { secret_id: address }.to_json)
      end

      private

      def oauth
        raise MissingCredentials if [@host, @uid, @secret].any?(&:nil?)

        @_oauth = Oauth.new(uid: @uid, secret: @secret, host: @host)
      end
    end
  end
end
