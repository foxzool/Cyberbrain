module Cyberbrain
  module API
    module Presenters
      module UserPresenter
        include Roar::JSON::JSONAPI
        include Grape::Roar::Representer

        type :users

        property :id
        property :username
      end
    end
  end
end
