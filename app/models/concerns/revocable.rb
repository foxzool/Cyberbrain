module Cyberbrain
  module Models
    module Revocable
      extend ActiveSupport::Concern

      included do
        def revoke(clock = DateTime)
          update_attribute :revoked_at, clock.now
        end

        def revoked?
          !(revoked_at && revoked_at <= DateTime.now).nil?
        end
      end
    end
  end
end
