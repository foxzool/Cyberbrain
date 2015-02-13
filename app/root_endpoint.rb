module Cyberbrain
  module Api
    class RootEndpoint < Grape::API
      prefix 'api'
      format :json
      formatter :json, Grape::Formatter::Roar

      desc 'Cyberbrain Api.'
      get do
        present self, with: Cyberbrain::Api::Presenters::RootPresenter
      end

      # mount Acme::Api::SplinesEndpoint
      mount Cyberbrain::Api::UsersEndpoint

      add_swagger_documentation api_version: 'v1'
    end
  end
end
