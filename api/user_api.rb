class UserAPI < Grape::API
  helpers APIHelpers

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
      ap permitted_params(params)
      user = User.create!(permitted_params(params)[:user])
    end
  end
end
