module Cyberbrain
  class AccessGrant < ActiveRecord::Base
    self.table_name = 'oauth_access_grants'.to_sym

    belongs_to :application, class_name: 'Cyberbrain::Application', inverse_of: :access_grants

    validates :resource_owner_id, :application_id, :token, :expires_in, :redirect_uri, presence: true
    validates :token, uniqueness: true

    before_validation :generate_token, on: :create

    scope :by_token, ->(token) { where(token: token).limit(1).to_a.first }

    private

    def generate_token
      self.token = UniqueToken.generate
    end
  end
end
