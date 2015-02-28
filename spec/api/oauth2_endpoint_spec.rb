require 'spec_helper'

describe Cyberbrain::API::OAuth2Endpoint do
  include Rack::Test::Methods

  def app
    Cyberbrain::API::RootEndpoint
  end

  let(:application) { FactoryGirl.create :application }
  let(:account) { FactoryGirl.create :account, password: '123' }
  let(:access_token) do
    FactoryGirl.create :access_token,
                       application: application,
                       resource_owner_id: account.id,
                       use_refresh_token: true
  end

  # TODO: check json response
  describe 'POST /api/v1/oauth2/token' do
    let(:grant) { FactoryGirl.create :access_grant }
    context 'grant_type is authorization_code' do
      it 'return access token' do
        post '/api/v1/oauth2/token',
             grant_type: :authorization_code,
             code: grant.token,
             redirect_uri: application.redirect_uri,
             client_id: application.uid,
             client_secret: application.secret

        expect(last_response.status).to eq(200)
      end
    end

    context 'grant_type is client_credentials' do
      it 'return access token' do
        post '/api/v1/oauth2/token',
             grant_type: :client_credentials,
             client_id: application.uid,
             client_secret: application.secret

        expect(last_response.status).to eq(200)
      end
    end

    context 'grant_type is password' do
      it 'return access token' do
        post '/api/v1/oauth2/token',
             grant_type: :password,
             username: account.username,
             password: '123',
             client_id: application.uid,
             client_secret: application.secret

        expect(last_response.status).to eq(200)
      end
    end

    context 'grant_type is refresh_toke' do
      it 'refresh old token' do
        post '/api/v1/oauth2/token',
             grant_type: :refresh_token,
             refresh_token: access_token.refresh_token,
             client_id: application.uid,
             client_secret: application.secret
        expect(last_response.status).to eq(200)
      end
    end

    context 'grant_type is unknown' do
      it 'raise error when grant_type not support' do
        post '/api/v1/oauth2/token',
             grant_type: :unknown,
             client_id: application.uid,
             client_secret: application.secret

        expect(last_response.status).to eq(400)
      end
    end
  end

  describe 'POST /api/v1/oauth2/revoke' do
    it 'revoke access token' do
      post '/api/v1/oauth2/revoke',
           token_type_hint: 'access_token',
           token: access_token.token,
           client_id: application.uid,
           client_secret: application.secret

      expect(last_response.status).to eq(201)
    end

    it 'revoke refresh token' do
      post '/api/v1/oauth2/revoke',
           token_type_hint: 'refresh_token',
           token: access_token.refresh_token,
           client_id: application.uid,
           client_secret: application.secret

      expect(last_response.status).to eq(201)
    end
  end
end
