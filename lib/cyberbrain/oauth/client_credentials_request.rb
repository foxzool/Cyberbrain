require 'Cyberbrain/oauth/client_credentials/creator'
require 'Cyberbrain/oauth/client_credentials/issuer'
require 'Cyberbrain/oauth/client_credentials/validation'

module Cyberbrain
  module OAuth
    class ClientCredentialsRequest
      include Validations
      include OAuth::RequestConcern

      attr_accessor :issuer, :server, :client, :original_scopes
      attr_reader :response
      alias :error_response :response

      delegate :error, to: :issuer

      def issuer
        @issuer ||= Issuer.new(server, Validation.new(server, self))
      end

      def initialize(server, client, parameters = {})
        @client, @server = client, server
        @response        = nil
        @original_scopes = parameters[:scope]
      end

      def access_token
        issuer.token
      end

      private

      def valid?
        issuer.create(client, scopes)
      end
    end
  end
end
