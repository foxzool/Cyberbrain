module Cyberbrain
  module Api
    class RootEndpoint < Grape::API
      prefix 'api'
      format :json
      formatter :json, Grape::Formatter::Roar

      mount Cyberbrain::Api::UsersEndpoint
    end
  end
end
