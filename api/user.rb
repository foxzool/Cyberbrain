class UserAPI < Grape::API
  resource :users do
    get '/:id' do
      ::User.find(params[:id])
    end
  end
end
