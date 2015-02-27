require 'spec_helper'

describe Cyberbrain::API::AccountsEndpoint do
  include Rack::Test::Methods

  def app
    Cyberbrain::API::RootEndpoint
  end

  let(:account) { FactoryGirl.create :account }
  let(:access_token) { Cyberbrain::AccessToken.create(resource_owner_id: account.id) }

  describe 'GET /api/v1/accounts/{id}' do
    it 'return user info' do
      header 'Authorization', 'bearer ' + access_token.token
      get "/api/v1/accounts/#{account.id}.json"

      expect(last_response.status).to eq(200)
    end
  end

  describe 'POST /api/v1/accounts' do
    it 'return user info' do
      password = Faker::Internet.password
      post '/api/v1/accounts.json', account: { username: Faker::Name.first_name,
                                         password: password,
                                         password_confirmation: password }

      expect(last_response.status).to eq 201
      expect(JSON.parse(last_response.body)['accounts']).to include('username')
    end
  end

  describe 'GET /API/v1/accounts/current' do
    it 'return current user info' do
      header 'Authorization', 'bearer ' + access_token.token
      get '/api/v1/accounts/current.json'

      expect(last_response.status).to eq 200
    end
  end

  describe 'DELETE /api/v1/accounts/{id}' do
    it 'destroy specify user' do
      header 'Authorization', 'bearer ' + access_token.token
      delete "/api/v1/accounts/#{account.id}.json"

      expect(last_response.status).to eq 200
    end
  end
end
