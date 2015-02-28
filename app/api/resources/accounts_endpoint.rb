module Cyberbrain
  module API
    class AccountsEndpoint < Grape::API
      resource :accounts do
        desc 'return current account'
        get '/current' do
          guard! scopes: ['account']
          present @current_account, with: Cyberbrain::API::Presenters::AccountPresenter
        end

        desc 'return specify account info'
        get '/:id' do
          account = Account.find(params[:id])
          present account, with: Cyberbrain::API::Presenters::AccountPresenter
        end

        desc 'account registration'
        params do
          requires :account, type: Hash do
            requires :username, type: String
            requires :password, type: String
            requires :password_confirmation, type: String
          end
        end
        post '/' do
          account = Account.create!(permitted_params[:account])
          present account, with: Cyberbrain::API::Presenters::AccountPresenter
        end

        desc 'destroy specify account'
        delete '/:id' do
          guard! scopes: ['account']
          account = Account.find(params[:id])
          account.destroy!

          { ok: true }
        end
      end
    end
  end
end
