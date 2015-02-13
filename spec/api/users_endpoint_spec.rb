require 'spec_helper'

describe Cyberbrain::Api::UsersEndpoint do
  include Rack::Test::Methods

  def app
    Cyberbrain::Api::RootEndpoint
  end

  describe 'POST /api/users' do
    it 'return user json' do
      password = Faker::Internet.password
      post '/api/users', user: { name: Faker::Name.name,
                                 password: password,
                                 password_confirmation: password }

      ap last_response.body
      expect(last_response.status).to eq 201
    end
  end
end
