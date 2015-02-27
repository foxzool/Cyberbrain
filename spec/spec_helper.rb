require 'rubygems'
if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
else
  require 'simplecov'
  SimpleCov.start do
    add_group 'api', 'api'
    add_group 'models', 'app/models'
    add_group 'policies', 'app/policies'

    add_filter 'spec'
    add_filter 'config'
    add_filter 'app/cyberbrain_app'
  end
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

  config.order = 'random'
end
