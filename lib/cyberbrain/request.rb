require 'cyberbrain/request/authorization_code'
require 'cyberbrain/request/client_credentials'
require 'cyberbrain/request/code'
require 'cyberbrain/request/password'
require 'cyberbrain/request/refresh_token'
require 'cyberbrain/request/token'

module Cyberbrain
  module Request
    module_function

    def authorization_strategy(strategy)
      get_strategy strategy, Cyberbrain.configuration.authorization_response_types
    rescue NameError
      raise Errors::InvalidAuthorizationStrategy
    end

    def token_strategy(strategy)
      get_strategy strategy, Cyberbrain.configuration.token_grant_types
    rescue NameError
      raise Errors::InvalidTokenStrategy
    end

    def get_strategy(strategy, available)
      fail Errors::MissingRequestStrategy unless strategy.present?
      fail NameError unless available.include?(strategy.to_s)
      "Cyberbrain::Request::#{strategy.to_s.camelize}".constantize
    end
  end
end
