require 'configatron'

module Cyberbrain
  def self.configuration
    configatron
  end
end

configatron.native_redirect_uri       = 'urn:ietf:wg:oauth:2.0:oob'
configatron.force_ssl_in_redirect_uri = ENV['RACK_ENV'] === 'development'
