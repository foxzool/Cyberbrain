module Cyberbrain
  module Helpers
    module API
      def authenticator(env)
        Rack::OAuth2::Server::Token.new do |req, res|
          client = Cyberbrain::Application.by_uid(req.client_id) || req.invalid_client!
          client.secret == req.client_secret || req.invalid_client!
          res.access_token = send(req.grant_type.to_s + '_flow', client, req)
        end.call(env)
      end

      private

      def authorization_code_flow(client, req)
        code = Cyberbrain::AccessGrant.by_token(req.code)
        req.invalid_grant! if code.blank? || code.redirect_uri != req.redirect_uri
        Cyberbrain::AccessToken.find_or_create_for(
          client,
          code.resource_owner_id,
          'public write',
          15.minutes,
          true
        ).to_bearer_token
      end

      def password_flow(client, req)
        account = Account.find_by(username: req.username).try(:authenticate, req.password) || req.invalid_grant!
        Cyberbrain::AccessToken.find_or_create_for(
          client,
          account.id,
          'public write',
          15.minutes,
          true
        ).to_bearer_token
      end

      def client_credentials_flow(client, _req)
        Cyberbrain::AccessToken.find_or_create_for(
          client,
          nil,
          'public write',
          15.minutes,
          true
        ).to_bearer_token
      end

      def refresh_token_flow(client, req)
        refresh_token = Cyberbrain::AccessToken.by_refresh_token(req.refresh_token)
        req.invalid_grant! unless refresh_token.try(:accessible?)
        Cyberbrain::AccessToken.find_or_create_for(
          client,
          refresh_token.resource_owner_id,
          'public write',
          15.minutes,
          true
        ).to_bearer_token
      end
    end
  end
end
