module ShareHelpers
  extend Grape::API::Helpers

  def permitted_params(params)
    @permitted_params ||= declared(params, include_missing: false)
  end
end
