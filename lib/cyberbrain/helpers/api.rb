module Cyberbrain
  module Helpers
    module API
      def authenticator(env)
        Rack::OAuth2::Server::Token.new do |req, res|
          client = Cyberbrain::Application.by_uid(req.client_id) || req.invalid_client!
          client.secret == req.client_secret || req.invalid_client!
          case req.grant_type
          when :authorization_code
            code = AuthorizationCode.valid.find_by_token(req.code)
            req.invalid_grant! if code.blank? || code.redirect_uri != req.redirect_uri
            res.access_token = code.access_token.to_bearer_token(:with_refresh_token)
          when :password
            account = Account.find_by(username: req.username).try(:authenticate, req.password) || req.invalid_grant!
            res.access_token = Cyberbrain::AccessToken.find_or_create_for(
              client,
              account.id,
              'public write',
              15.minutes,
              true
            ).to_bearer_token
          when :client_credentials
            # NOTE: client is already authenticated here.
            res.access_token = client.access_tokens.create.to_bearer_token
          when :refresh_token
            refresh_token = Cyberbrain::AccessToken.by_refresh_token(req.refresh_token)
            req.invalid_grant! unless refresh_token
            res.access_token = Cyberbrain::AccessToken.find_or_create_for(
              client,
              refresh_token.resource_owner_id,
              'public write',
              15.minutes,
              true
            ).to_bearer_token
          else
            # NOTE: extended assertion grant_types are not supported yet.
            req.unsupported_grant_type!
          end
        end.call(env)
      end
    end
  end
end
