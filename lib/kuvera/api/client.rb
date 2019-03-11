# frozen_string_literal: true

require 'json'
require 'net/http'

require 'kuvera/api/errors'

module Kuvera
  module Api
    class Client
      HOST = 'http://localhost:3000/'
      PATH = 'at/'
      ROOT = 'secret'

      RESPONSES = {
        200 => ->(response) { JSON.parse(response.body).fetch(ROOT) },
        403 => ->(_response) { raise SecretAlreadyRead },
        404 => ->(_response) { raise SecretNotFound }
      }.freeze

      def at(address)
        response = Net::HTTP.get_response(URI.join(HOST, PATH, address))
        RESPONSES.fetch(response.code.to_i).call(response)
      end
    end
  end
end
