module Cyberbrains
  class API < Grape::API
    prefix 'api'
    format :json
    mount ::API::Ping
    add_swagger_documentation api_version: 'v1'
  end
end
