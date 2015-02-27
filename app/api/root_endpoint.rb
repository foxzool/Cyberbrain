module Cyberbrain
  module API
    require 'helpers/api_guard'
    require 'helpers/strong_params_helpers'
    require 'resources/oauth2_endpoint'
    require 'resources/accounts_endpoint'
    require 'presenters/account_presenter'

    class RootEndpoint < Grape::API
      helpers StrongParamsHelpers
      include APIGuard

      prefix 'api'
      version 'v1', using: :path
      default_format :json

      content_type :xml, 'application/xml'
      content_type :json, 'application/json'

      formatter :json, Grape::Formatter::Roar

      mount AccountsEndpoint
      mount OAuth2Endpoint
    end
  end
end
