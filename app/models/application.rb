module Cyberbrain
  class Application < ActiveRecord::Base
    self.table_name = 'oauth_applications'.to_sym

    include OAuth::Helpers
    include Models::Scopes

    has_many :access_grants, dependent: :destroy, class_name: 'Cyberbrain::AccessGrant'
    has_many :access_tokens, dependent: :destroy, class_name: 'Cyberbrain::AccessToken'
    has_many :authorized_tokens, -> { where(revoked_at: nil) }, class_name: 'AccessToken'
    has_many :authorized_applications, through: :authorized_tokens, source: :application

    validates :name, :secret, :uid, presence: true
    validates :uid, uniqueness: true
    validates :redirect_uri, redirect_uri: true

    before_validation :generate_uid, :generate_secret, on: :create

    class << self
      def by_uid_and_secret(uid, secret)
        where(uid: uid, secret: secret).limit(1).to_a.first
      end

      def by_uid(uid)
        where(uid: uid).limit(1).to_a.first
      end

      def column_names_with_table
        column_names.map { |c| "#{table_name}.#{c}" }
      end

      def authorized_for(resource_owner)
        joins(:authorized_applications)
          .where(AccessToken.table_name => { resource_owner_id: resource_owner.id, revoked_at: nil })
          .group(column_names_with_table.join(',')).order('id')
      end
    end

    private

    def generate_uid
      self.uid ||= UniqueToken.generate
    end

    def generate_secret
      self.secret ||= UniqueToken.generate
    end
  end
end
