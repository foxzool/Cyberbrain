module AccountCenter
  class Ping < Grape::API
    format :json
    get '/ping' do
      { ping: 'pong' }
    end

    get '/user' do
      { user: User.last }
    end
  end
end
