module Cyberbrain
  class AccessToken < ActiveRecord::Base
    self.table_name = 'oauth_access_tokens'

    attr_writer :use_refresh_token

    belongs_to :application,
               class_name: 'Cyberbrain::Application',
               inverse_of: :access_tokens

    include OAuth::Helpers
    include Models::Expirable
    include Models::Revocable
    include Models::Accessible
    include Models::Scopes

    validates :token, presence: true, uniqueness: true
    validates :refresh_token, uniqueness: true, if: :use_refresh_token?

    # Results:
    VALID = :valid
    EXPIRED = :expired
    REVOKED = :revoked
    INSUFFICIENT_SCOPE = :insufficient_scope

    before_validation :generate_token, on: :create
    before_validation :generate_refresh_token,
                      on: :create,
                      if: :use_refresh_token?

    def to_bearer_token
      bearer_token = Rack::OAuth2::AccessToken::Bearer.new(
        access_token: token,
        expires_in: expires_in,
        scope: scopes_string,
        refresh_token: refresh_token
      )

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

    def token_type
      'bearer'
    end

    def use_refresh_token?
      !@use_refresh_token.nil?
    end

    def as_json(_options = {})
      {
        resource_owner_id: resource_owner_id,
        scopes: scopes,
        expires_in_seconds: expires_in_seconds,
        application: { uid: application.try(:uid) },
        created_at: created_at.to_i
      }
    end

    # It indicates whether the tokens have the same credential
    def same_credential?(access_token)
      application_id == access_token.application_id &&
        resource_owner_id == access_token.resource_owner_id
    end

    def acceptable?(scopes)
      accessible? && includes_scope?(*scopes)
    end

    class << self
      def by_token(token)
        where(token: token).limit(1).to_a.first
      end

      def by_refresh_token(refresh_token)
        where(refresh_token: refresh_token).first
      end

      def revoke_all_for(application_id, resource_owner)
        where(application_id: application_id,
              resource_owner_id: resource_owner.id,
              revoked_at: nil)
          .map(&:revoke)
      end

      def matching_token_for(application, resource_owner_or_id, scopes)
        resource_owner_id = if resource_owner_or_id.respond_to?(:to_key)
                              resource_owner_or_id.id
                            else
                              resource_owner_or_id
                            end
        token = last_authorized_token_for(application.try(:id), resource_owner_id)
        token if token && scopes_match?(token.scopes, scopes, application.try(:scopes))
      end

      def scopes_match?(token_scopes, param_scopes, app_scopes)
        (!token_scopes.present? && !param_scopes.present?) ||
          Cyberbrain::OAuth::Helpers::ScopeChecker.valid?(
            token_scopes.to_s,
            param_scopes,
            app_scopes
          )
      end

      def find_or_create_for(application, resource_owner_id, scopes, expires_in, use_refresh_token)
        if Cyberbrain.configuration.reuse_access_token
          access_token = matching_token_for(application, resource_owner_id, scopes)
          return access_token if access_token && !access_token.expired?
        end
        create!(
          application_id: application.try(:id),
          resource_owner_id: resource_owner_id,
          scopes: scopes.to_s,
          expires_in: expires_in,
          use_refresh_token: use_refresh_token
        )
      end

      def last_authorized_token_for(application_id, resource_owner_id)
        where(application_id: application_id,
              resource_owner_id: resource_owner_id,
              revoked_at: nil)
          .send(order_method, created_at_desc)
          .limit(1)
          .to_a
          .first
      end

      def order_method
        :order
      end

      def created_at_desc
        'created_at desc'
      end
    end

    private

    def generate_refresh_token
      write_attribute :refresh_token, UniqueToken.generate
    end

    def generate_token
      self.token = UniqueToken.generate
    end

    # True if the token's scope is a superset of required scopes,
    # or the required scopes is empty.
    def sufficent_scope?(req_scopes)
      if req_scopes.blank?
        # if no any scopes required, the scopes of token is sufficient.
        true
      else
        # If there are scopes required, then check whether
        # the set of authorized scopes is a superset of the set of required scopes
        required_scopes = Set.new(req_scopes)
        authorized_scopes = Set.new(scopes)

        authorized_scopes >= required_scopes
      end
    end

    def self.delete_all_for(application_id, resource_owner)
      where(application_id: application_id,
            resource_owner_id: resource_owner.id).delete_all
    end
  end
end
