module Cyberbrain
  module Errors
    class CyberbrainError < StandardError
    end

    class InvalidAuthorizationStrategy < CyberbrainError
    end

    class InvalidTokenStrategy < CyberbrainError
    end

    class MissingRequestStrategy < CyberbrainError
    end
  end
end
