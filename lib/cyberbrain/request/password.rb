module Cyberbrain
  module Request
    class Password
      def self.build(server)
        new(server.credentials, server.resource_owner, server)
      end

      attr_accessor :credentials, :resource_owner, :server

      def initialize(credentials, resource_owner, server)
        @credentials, @resource_owner, @server = credentials, resource_owner, server
      end

      def request
        @request ||= OAuth::PasswordAccessTokenRequest.new(Cyberbrain.configuration, credentials, resource_owner, server.parameters)
      end

      def authorize
        request.authorize
      end
    end
  end
end
