module Cyberbrain
  module Api
    class UsersEndpoint < Grape::API
      helpers ShareHelpers

      resource :users do
        desc 'return user info'
        get '/:id' do
          user = User.find(params[:id])
          present user, with: Cyberbrain::Api::Presenters::UserPresenter
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

        desc 'destroy user'
        delete '/:id' do
          user = User.find(params[:id])
          user.destroy!

          { ok: true }
        end
      end
    end
  end
end
