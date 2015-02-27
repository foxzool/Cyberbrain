module Cyberbrain
  module API
    module Presenters
      module AccountPresenter
        include Roar::JSON::JSONAPI
        include Grape::Roar::Representer

        type :accounts

        property :id
        property :username
      end
    end
  end
end
