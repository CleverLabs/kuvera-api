# frozen_string_literal: true

module Kuvera
  module Api
    SecretNotFound = Class.new(StandardError)
    SecretAlreadyRead = Class.new(StandardError)
  end
end
