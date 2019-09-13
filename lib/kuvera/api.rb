# frozen_string_literal: true

require 'forwardable'

require 'kuvera/api/version'
require 'kuvera/api/client'

module Kuvera
  module Api
    extend SingleForwardable

    module_function

    def_delegators :client, :at, :me, :upload, :share

    def client
      @client ||= Client.new
    end
  end
end
