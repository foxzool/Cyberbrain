module Cyberbrain
  module Models
    module Accessible
      extend ActiveSupport::Concern

      included do
        def accessible?
          !expired? && !revoked?
        end
      end
    end
  end
end
