module Cyberbrain
  module API
    class UsersEndpoint < Grape::API
      resource :users do
        desc 'return current user'
        get '/current' do
          guard!
          present @current_user, with: Cyberbrain::API::Presenters::UserPresenter
        end

        desc 'return specify user info'
        get '/:id' do
          guard!
          user = User.find(params[:id])
          present user, with: Cyberbrain::API::Presenters::UserPresenter
        end

        desc 'user registration'
        params do
          requires :user, type: Hash do
            requires :username, type: String
            requires :password, type: String
            requires :password_confirmation, type: String
          end
        end
        post '/' do
          user = User.create!(permitted_params[:user])
          present user, with: Cyberbrain::API::Presenters::UserPresenter
        end

        desc 'destroy specify user'
        delete '/:id' do
          guard!
          user = User.find(params[:id])
          user.destroy!

          { ok: true }
        end
      end
    end
  end
end
