require 'spec_helper'

describe Cyberbrain::API::OAuth2Endpoint do
  include Rack::Test::Methods

  def app
    Cyberbrain::API::RootEndpoint
  end

  let(:user) { FactoryGirl.create :user, password: '123' }
  let(:access_token) { Cyberbrain::AccessToken.create(resource_owner_id: user.id) }

  describe 'POST /api/v1/oauth2/token' do
    it 'get access token' do
      post '/api/v1/oauth2/token',
           grant_type: :password,
           username:   user.username,
           password:   '123',
           client_id:  1
      expect(last_response.status).to eq(200)
    end

    it 'refresh old token' do
      post '/api/v1/oauth2/token',
           grant_type: :refresh_token,
           token:      access_token.refresh_token,
           client_id:  1
    end
  end

  describe 'POST /api/v1/oauth2/revoke' do
    it 'revoke access token' do
      post '/api/v1/oauth2/revoke',
           token_type_hint: 'access_token',
           token:           access_token.token

      expect(last_response.status).to eq(201)
    end

    it 'revoke refresh token' do
      post '/api/v1/oauth2/revoke',
           token_type_hint: 'refresh_token',
           token:           access_token.refresh_token

      expect(last_response.status).to eq(201)
    end
  end
end
