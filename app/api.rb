module Cyberbrain
  class API < Grape::API
    prefix 'api'
    version 'v1', using: :path
    format :json
    mount UserAPI

    add_swagger_documentation api_version: 'v1'
  end
end
