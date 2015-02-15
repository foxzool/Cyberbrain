require 'rubygems'
require 'simplecov'

SimpleCov.start do
  add_group 'api', 'api'
  add_group 'models', 'app/models'

  add_filter 'spec'
  add_filter 'config'
  add_filter 'app/cyberbrain_app'
end

ENV['RACK_ENV'] ||= 'test'

require 'rack/test'

require File.expand_path('../../config/environment', __FILE__)

Dir[File.expand_path('../../spec/support/**/*.rb', __FILE__)].each do |f|
  require f
end

require 'shoulda/matchers'

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.raise_errors_for_deprecations!
end
