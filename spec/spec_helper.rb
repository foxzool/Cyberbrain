require 'rubygems'
require 'simplecov'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

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
