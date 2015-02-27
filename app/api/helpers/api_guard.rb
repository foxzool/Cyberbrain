# Guard API with OAuth 2.0 Access Token

require 'rack/oauth2'

module APIGuard
  extend ActiveSupport::Concern

  included do |base|
    # OAuth2 Resource Server Authentication
    use Rack::OAuth2::Server::Resource::Bearer do |request|
      # The authenticator only fetches the raw token string
      # Must yield access token to store it in the env
      request.access_token
    end

    helpers HelperMethods

    install_error_responders(base)
  end

  # Helper Methods for Grape Endpoint
  module HelperMethods
    # Invokes the Cyberbrain guard.
    #
    # If token string is blank, then it fails MissingTokenError.
    #
    # If token is presented and valid, then it sets @current_user.
    #
    # If the token does not have sufficient scopes to cover the requred scopes,
    # then it fails InsufficientScopeError.
    #
    # If the token is expired, then it fails ExpiredError.
    #
    # If the token is revoked, then it fails RevokedError.
    #
    # If the token is not found (nil), then it fails TokenNotFoundError.
    #
    # Arguments:
    #
    #   scopes: (optional) scopes required for this guard.
    #           Defaults to empty array.
    #
    def guard!(scopes: [])
      token_string = request.env[Rack::OAuth2::Server::Resource::ACCESS_TOKEN]

      if token_string.blank?
        fail MissingTokenError

      elsif (access_token = Cyberbrain::AccessToken.by_token(token_string)).nil?
        fail TokenNotFoundError

      else
        case access_token.verify(scopes)
        when Cyberbrain::AccessToken::INSUFFICIENT_SCOPE
          fail InsufficientScopeError, scopes

        when Cyberbrain::AccessToken::EXPIRED
          fail ExpiredError

        when Cyberbrain::AccessToken::REVOKED
          fail RevokedError

        when Cyberbrain::AccessToken::VALID
          @current_account = Cyberbrain::Account.find(access_token.resource_owner_id)
        else
          fail TokenNotFoundError
        end
      end
    end

    attr_reader :current_user
  end

  module ClassMethods
    # Installs the Cyberbrain guard on the whole Grape API endpoint.
    #
    # Arguments:
    #
    #   scopes: (optional) scopes required for this guard.
    #           Defaults to empty array.
    #
    def guard_all!(scopes: [])
      before do
        guard! scopes: scopes
      end
    end

    private

    def install_error_responders(base)
      error_classes = [MissingTokenError, TokenNotFoundError,
                       ExpiredError, RevokedError, InsufficientScopeError]

      base.send :rescue_from, *error_classes, bearer_token_error_handler
    end

    def bearer_token_error_handler
      proc do |e|
        response = case e
                   when MissingTokenError
                     Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new

                   when TokenNotFoundError
                     Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
                       :invalid_token,
                       'Bad Access Token.')

                   when ExpiredError
                     Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
                       :invalid_token,
                       'Token is expired. You can either do re-authorization or token refresh.')

                   when RevokedError
                     Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
                       :invalid_token,
                       'Token was revoked. You have to re-authorize from the user.')

                   when InsufficientScopeError
                     # FIXME: ForbiddenError (inherited from Bearer::Forbidden of Rack::Oauth2)
                     # does not include WWW-Authenticate header, which breaks the standard.
                     Rack::OAuth2::Server::Resource::Bearer::Forbidden.new(
                       :insufficient_scope,
                       Rack::OAuth2::Server::Resource::ErrorMethods::DEFAULT_DESCRIPTION[:insufficient_scope],
                       scope: e.scopes)
                   else
                     Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new
                   end

        response.finish
      end
    end
  end

  #
  # Exceptions
  #

  class MissingTokenError < StandardError
  end

  class TokenNotFoundError < StandardError
  end

  class ExpiredError < StandardError
  end

  class RevokedError < StandardError
  end

  class InsufficientScopeError < StandardError
    attr_reader :scopes

    def initialize(scopes)
      @scopes = scopes
    end
  end
end
