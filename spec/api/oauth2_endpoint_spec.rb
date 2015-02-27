require 'spec_helper'

describe Cyberbrain::API::OAuth2Endpoint do
  include Rack::Test::Methods

  def app
    Cyberbrain::API::RootEndpoint
  end

  let(:application) { FactoryGirl.create :application }
  let(:account) { FactoryGirl.create :account, password: '123' }
  let(:access_token) { FactoryGirl.create :access_token,
                                          application: application,
                                          resource_owner_id: account.id,
                                          use_refresh_token: true }

  describe 'POST /api/v1/oauth2/token' do
    it 'get access token' do
      post '/api/v1/oauth2/token',
           grant_type: :password,
           username: account.username,
           password: '123',
           client_id: application.uid,
           client_secret: application.secret

      expect(last_response.status).to eq(200)
    end

    it 'refresh old token' do
      post '/api/v1/oauth2/token',
           grant_type: :refresh_token,
           refresh_token: access_token.refresh_token,
           client_id: application.uid,
           client_secret: application.secret
      expect(last_response.status).to eq(200)
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
