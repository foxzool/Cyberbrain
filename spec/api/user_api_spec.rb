require 'spec_helper'

describe UserAPI do
  include Rack::Test::Methods

  def app
    Cyberbrain::API
  end

  describe 'POST /api/v1/users' do
    it 'return user json' do
      password = Faker::Internet.password
      post '/api/v1/users', { user: { name:                  Faker::Internet.name,
                                      password:              password,
                                      password_confirmation: password } }
      ap last_response
      expect(last_response.status).to eq 201
    end
  end
end
