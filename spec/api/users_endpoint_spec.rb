require 'spec_helper'

describe Cyberbrain::Api::UsersEndpoint do
  include Rack::Test::Methods

  def app
    Cyberbrain::Api::RootEndpoint
  end

  let(:user) { FactoryGirl.create :user }

  describe 'GET /api/users/{id}' do
    it 'return user info' do
      get '/api/users/' + user.id

      expect(last_response.status).to eq(200)
    end
  end

  describe 'POST /api/users' do
    it 'return user info' do
      password = Faker::Internet.password
      post '/api/users', user: { name: Faker::Name.first_name,
                                 password: password,
                                 password_confirmation: password }

      expect(last_response.status).to eq 201
    end
  end

  describe 'DELETE /api/users/{id}' do
    it 'destroy specify user' do
      delete '/api/users/' + user.id

      expect(last_response.status).to eq 200
    end
  end
end
