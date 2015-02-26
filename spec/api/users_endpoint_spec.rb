require 'spec_helper'

describe Cyberbrain::API::UsersEndpoint do
  include Rack::Test::Methods

  def app
    Cyberbrain::API::RootEndpoint
  end

  let(:user) { FactoryGirl.create :user }
  let(:access_token) { Cyberbrain::AccessToken.create(user_id: user.id) }

  describe 'GET /api/v1/users/{id}' do
    it 'return user info' do
      header 'Authorization', 'bearer ' + access_token.token
      get "/api/v1/users/#{user.id}.json"

      expect(last_response.status).to eq(200)
    end
  end

  describe 'POST /api/v1/users' do
    it 'return user info' do
      password = Faker::Internet.password
      post '/api/v1/users.json', user: { username:              Faker::Name.first_name,
                                         password:              password,
                                         password_confirmation: password }

      expect(last_response.status).to eq 201
      expect(JSON.parse(last_response.body)['users']).to include('username')
    end
  end

  describe 'GET /API/v1/users/current' do
    it 'return current user info' do
      header 'Authorization', 'bearer ' + access_token.token
      get '/api/v1/users/current.json'

      expect(last_response.status).to eq 200
    end
  end

  describe 'DELETE /api/v1/users/{id}' do
    it 'destroy specify user' do
      header 'Authorization', 'bearer ' + access_token.token
      delete "/api/v1/users/#{user.id}.json"

      expect(last_response.status).to eq 200
    end
  end
end
