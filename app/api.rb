module AccountCenter
  class API < Grape::API
    prefix 'api'
    format :json
    mount ::AccountCenter::Ping
    add_swagger_documentation api_version: 'v1'
  end
end
