# frozen_string_literal: true

require 'json'
require 'net/http'

require 'kuvera/api/errors'

module Kuvera
  module Api
    class Client
      HOST = 'https://kuvera.io/'
      PATH = 'at/'
      ROOT = 'secret'

      def initialize(host: nil)
        @host = host || ENV.fetch("KUVERA_API", HOST)
      end

      RESPONSES = {
        200 => ->(response) { JSON.parse(response.body).fetch(ROOT) },
        403 => ->(_response) { raise SecretAlreadyRead },
        404 => ->(_response) { raise SecretNotFound }
      }.freeze

      def at(address)
        response = Net::HTTP.get_response(URI.join(@host, PATH, address))
        RESPONSES.fetch(response.code.to_i).call(response)
      end
    end
  end
end
