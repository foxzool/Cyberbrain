require 'spec_helper'

describe Cyberbrain::API::AccountsEndpoint do
  include Rack::Test::Methods

  def app
    Cyberbrain::API::RootEndpoint
  end

  let(:account) { FactoryGirl.create :account }
  let(:application) { FactoryGirl.create :application }
  let(:access_token) do
    FactoryGirl.create(:access_token,
                       resource_owner_id: account.id,
                       application: application,
                       scopes: 'account')
  end

  describe 'GET /api/v1/accounts/{id}' do
    it 'return account info' do
      header 'Authorization', 'bearer ' + access_token.token
      get "/api/v1/accounts/#{account.id}.json"

      expect(last_response.status).to eq(200)
    end
  end

  describe 'POST /api/v1/accounts' do
    it 'return account info' do
      password = Faker::Internet.password
      post '/api/v1/accounts.json', account: { username: Faker::Name.first_name,
                                               password: password,
                                               password_confirmation: password }
      expect(last_response.status).to eq 201
      expect(JSON.parse(last_response.body)['accounts']).to include('username')
    end
  end

  describe 'GET /API/v1/accounts/current' do
    it 'return current account info' do
      header 'Authorization', 'bearer ' + access_token.token
      get '/api/v1/accounts/current.json'

      expect(last_response.status).to eq 200
    end

    context 'invalid oauth request' do
      it 'with miss token' do
        get '/api/v1/accounts/current.json'

        expect(last_response.status).to eq 401
      end

      it 'with wrong token' do
        header 'Authorization', 'bearer ' + 'unknown'
        get '/api/v1/accounts/current.json'

        expect(last_response.status).to eq 401
      end

      it 'with wrong scopes' do
        access_token = FactoryGirl.create(:access_token,
                                          resource_owner_id: account.id,
                                          application: application,
                                          scopes: 'more')
        header 'Authorization', 'bearer ' + access_token.token
        get '/api/v1/accounts/current.json'

        expect(last_response.status).to eq 403
      end

      it 'with expire token' do
        header 'Authorization', 'bearer ' + access_token.token
        Timecop.travel(1.day)
        get '/api/v1/accounts/current.json'

        expect(last_response.status).to eq 401
      end

      it 'with revoked token' do
        access_token.revoke
        header 'Authorization', 'bearer ' + access_token.token
        get '/api/v1/accounts/current.json'

        expect(last_response.status).to eq 401
      end
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
