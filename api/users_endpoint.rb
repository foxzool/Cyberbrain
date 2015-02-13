module Cyberbrain
  module Api
    class UsersEndpoint < Grape::API
      helpers ShareHelpers

      resource :users do
        get '/:id' do
          User.find(params[:id])
        end

        desc 'user registration'
        params do
          requires :user, type: Hash do
            requires :name, type: String
            requires :password, type: String
            requires :password_confirmation, type: String
          end
        end
        post '/' do
          user = User.create!(permitted_params(params)[:user])
          present user, with: Cyberbrain::Api::Presenters::UserPresenter
        end
      end
    end
  end
end
