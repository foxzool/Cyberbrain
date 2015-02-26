class GenerateOauthToken
  def self.for(env)
    GenerateOauthToken.new.execute(env)
  end

  def execute(env)
    Rack::OAuth2::Server::Token.new do |req, res|
      # client = Client.verify(req.client_id)
      # req.invalid_client! unless client
      authorization_class = GenerateOauthToken.const_get(classify(req.grant_type))
      res.access_token = authorization_class.validate(req)
    end.call(env)
  end

  def classify(symbol)
    symbol.to_s.split('_').map(&:capitalize).join
  end

  # class AuthorizationCode
  #   def self.validate(_client, req)
  #     req.invalid_grant! unless ::AuthorizationCode.verify(req.code)
  #     AccessToken.build.to_bearer_token(true)
  #   end
  # end

  class RefreshToken
    def self.validate(_client, req)
      req.invalid_grant! unless ::RefreshToken.verify(req.refresh_token)
      OauthAccessToken.build.to_bearer_token
    end
  end
  #
  # class ClientCredentials
  #   def self.validate(client, req)
  #     req.invalid_grant! unless client.secret == req.client_secret
  #     AccessToken.build.to_bearer_token(true)
  #   end
  # end

  class Password
    def self.validate(req)
      user = User.find_by(username: req.username)
      req.invalid_request! unless user && user.authenticate(req.password)
      OauthAccessToken.create(user_id: user.id).to_bearer_token(true)
    end
  end
end
