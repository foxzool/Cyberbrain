require 'roar/json/json_api'

module Cyberbrain
  module Api
    module Presenters
      module UserPresenter
        include Roar::JSON::JSONAPI
        include Grape::Roar::Representer

        type :users

        property :id
        property :name
      end
    end
  end
end
