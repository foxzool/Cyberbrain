module Cyberbrain
  module Models
    module Scopes
      extend ActiveSupport::Concern

      included do
        def scopes
          Cyberbrain::OAuth::Scopes.from_string(self[:scopes])
        end

        def scopes_string
          self[:scopes]
        end

        def includes_scope?(*required_scopes)
          required_scopes.blank? || required_scopes.any? { |s| scopes.exists?(s.to_s) }
        end
      end
    end
  end
end
