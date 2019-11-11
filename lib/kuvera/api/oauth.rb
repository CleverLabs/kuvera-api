# frozen_string_literal: true

require 'oauth2'
require 'net/http/post/multipart'

module Kuvera
  module Api
    class Oauth
      DEFAULT_CONTENT_TYPE = { 'Content-Type' => 'application/json' }.freeze
      FATAL_ERROR_MESSAGE = { 'error' => 'Internal error' }.freeze
      CLIENT_SCOPE = 'ext_app'

      def initialize(uid:, secret:, host:)
        @oauth_client = OAuth2::Client.new(
          uid, secret, site: host, token_method: :post
        ) do |stack|
          stack.request :multipart
          stack.request :url_encoded
          stack.adapter Faraday.default_adapter
        end
      end

      def get(url, params = {})
        token.get(url, params: params).parsed
      rescue OAuth2::Error => error
        process_exception(error)
      end

      def post(url, body, headers: DEFAULT_CONTENT_TYPE.dup)
        token.post(url, headers: headers, body: body).parsed
      rescue OAuth2::Error => error
        process_exception(error)
      end

      private

      def token
        @token ||=
          @oauth_client.client_credentials.get_token(scope: CLIENT_SCOPE)
      end

      def process_exception(exception)
        exception.response.parsed || FATAL_ERROR_MESSAGE
      end
    end
  end
end
