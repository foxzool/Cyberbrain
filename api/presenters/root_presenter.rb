module Cyberbrain
  module Api
    module Presenters
      module RootPresenter
        include Roar::JSON::HAL
        include Roar::Hypermedia
        include Grape::Roar::Representer

        link :self do |opts|
          "#{base_url(opts)}/api"
        end

        link :swagger_doc do |opts|
          "#{base_url(opts)}/api/swagger_doc"
        end

        private

        def base_url(opts)
          request = Grape::Request.new(opts[:env])
          request.base_url
        end
      end
    end
  end
end
