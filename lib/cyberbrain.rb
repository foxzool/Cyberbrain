require 'cyberbrain/version'
require 'cyberbrain/config'

require 'cyberbrain/oauth/helpers/scope_checker'
require 'cyberbrain/oauth/helpers/unique_token'

require 'cyberbrain/oauth/scopes'

require 'cyberbrain/helpers/api'

Cyberbrain.configure do
  orm :active_record
  default_scopes :account
end
