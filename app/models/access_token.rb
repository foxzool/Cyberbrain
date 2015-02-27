module Cyberbrain
  class AccessToken < ActiveRecord::Base

    self.table_name = 'oauth_access_tokens'

    belongs_to :application,
               class_name: 'Cyberbrain::Application',
               inverse_of: :access_tokens

    include Expirable
    include Revocable
    include Accessible
    include Models::Scopes

    # Results:
    VALID              = :valid
    EXPIRED            = :expired
    REVOKED            = :revoked
    INSUFFICIENT_SCOPE = :insufficient_scope

    before_validation :generate_token, on: :create

    scope :by_token, ->(token) { where(token: token).limit(1).to_a.first }
    scope :by_refresh_token, ->(refresh_token) { where(refresh_token: refresh_token).first }

    def to_bearer_token(with_refresh_token = false)
      bearer_token = Rack::OAuth2::AccessToken::Bearer.new(
        access_token: token,
        expires_in:   expires_in,
        scope:        scopes_string
      )

      if with_refresh_token
        update(refresh_token: UniqueToken.generate, expires_in: 15.minutes)
        bearer_token.refresh_token = refresh_token
      end

      bearer_token
    end

    def verify(scopes = [])
      if expired?
        EXPIRED

      elsif revoked?
        REVOKED

      elsif !sufficent_scope?(scopes)
        INSUFFICIENT_SCOPE
      else
        VALID
      end
    end

    private

    def generate_token
      self.token         = UniqueToken.generate
      self.refresh_token = UniqueToken.generate
      self.expires_in    = 15.minutes
    end

    # True if the token's scope is a superset of required scopes,
    # or the required scopes is empty.
    def sufficent_scope?(scopes)
      if scopes.blank?
        # if no any scopes required, the scopes of token is sufficient.
        true
      else
        # If there are scopes required, then check whether
        # the set of authorized scopes is a superset of the set of required scopes
        required_scopes   = Set.new(scopes)
        authorized_scopes = Set.new(self.scopes)

        authorized_scopes >= required_scopes
      end
    end
  end
end
