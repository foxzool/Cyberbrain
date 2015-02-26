require 'api/root_endpoint'
require 'rack/oauth2'
Rack::OAuth2.debug!
module Cyberbrain
  class App
    def initialize
      @filenames   = ['', '.html', 'index.html', '/index.html']
      @rack_static = ::Rack::Static.new(-> { [404, {}, []] },
                                        root: File.expand_path('../../public', __FILE__),
                                        urls: ['/']
      )
    end

    # rubocop:disable MethodLength
    def self.instance
      @instance ||= Rack::Builder.new do
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: :get
          end
        end

        run Cyberbrain::App.new
      end.to_app
    end

    def call(env)
      # api
      response = Cyberbrain::API::RootEndpoint.call(env)

      # Serve error pages or respond with API response
      case response[0]
      when 404, 500
        content = @rack_static.call(env.merge('PATH_INFO' => "/errors/#{response[0]}.html"))
        [response[0], content[1], content[2]]
      else
        response
      end
    end
  end
end
