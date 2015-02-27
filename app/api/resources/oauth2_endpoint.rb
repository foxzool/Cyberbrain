module Cyberbrain
  module API
    class OAuth2Endpoint < Grape::API
      helpers Cyberbrain::Helpers::API

      resource :oauth2 do
        params do
          requires :grant_type,
                   type:   Symbol,
                   values: [:authorization_code, :refresh_token, :client_credentials, :password],
                   desc:   'The grant type.'
          optional :code,
                   type: String,
                   desc: 'The authorization code.'
          optional :client_id,
                   type: String,
                   desc: 'The client id.'
          optional :client_secret,
                   type: String,
                   desc: 'The client secret.'
          optional :refresh_token,
                   type: String,
                   desc: 'The refresh_token.'
        end
        post :token do
          response = authenticator(env)
          # status
          status response[0]

          # headers
          response[1].each do |key, value|
            header key, value
          end

          # body
          body JSON.parse(response[2].body.first)
        end

        post :revoke do
          access_token = if params[:token_type_hint] == 'access_token'
                           Cyberbrain::AccessToken.by_token(params[:token])
                         else
                           Cyberbrain::AccessToken.by_refresh_token(params[:token])
                         end
          access_token.revoke if access_token.accessible?
          {}
        end
      end
    end
  end
end
