module Cyberbrain
  module API
    require 'concerns/api_guard'
    require 'concerns/strong_params_helpers'
    require 'resources/oauth2_endpoint'
    require 'resources/users_endpoint'
    require 'presenters/user_presenter'

    class RootEndpoint < Grape::API
      helpers StrongParamsHelpers
      include APIGuard

      prefix 'api'
      version 'v1', using: :path
      default_format :json

      content_type :xml, 'application/xml'
      content_type :json, 'application/json'

      formatter :json, Grape::Formatter::Roar

      mount UsersEndpoint
      mount OAuth2Endpoint
    end
  end
end
