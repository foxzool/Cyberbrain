require 'cyberbrain/version'
require 'cyberbrain/config'

require 'cyberbrain/errors'
require 'cyberbrain/server'
require 'cyberbrain/request'
require 'cyberbrain/validations'

require 'cyberbrain/oauth/authorization/code'
require 'cyberbrain/oauth/authorization/token'
require 'cyberbrain/oauth/authorization/uri_builder'
require 'cyberbrain/oauth/helpers/scope_checker'
require 'cyberbrain/oauth/helpers/uri_checker'
require 'cyberbrain/oauth/helpers/unique_token'

require 'cyberbrain/oauth/scopes'
require 'cyberbrain/oauth/error'
require 'cyberbrain/oauth/code_response'
require 'cyberbrain/oauth/token_response'
require 'cyberbrain/oauth/error_response'
require 'cyberbrain/oauth/pre_authorization'
require 'cyberbrain/oauth/request_concern'
require 'cyberbrain/oauth/authorization_code_request'
require 'cyberbrain/oauth/refresh_token_request'
require 'cyberbrain/oauth/password_access_token_request'
require 'cyberbrain/oauth/client_credentials_request'
require 'cyberbrain/oauth/code_request'
require 'cyberbrain/oauth/token_request'
require 'cyberbrain/oauth/client'
require 'cyberbrain/oauth/token'
require 'cyberbrain/oauth/invalid_token_response'
require 'cyberbrain/oauth/forbidden_token_response'

require 'cyberbrain/helpers/api'

module Cyberbrain
  def self.configured?
    @config.present?
  end

  def self.database_installed?
    [AccessToken, AccessGrant, Application].all? { |model| model.table_exists? }
  end

  def self.installed?
    configured? && database_installed?
  end

  def self.authenticate(request, methods = Cyberbrain.configuration.access_token_methods)
    OAuth::Token.authenticate(request, *methods)
  end
end

Cyberbrain.configure do
  orm :active_record
end
