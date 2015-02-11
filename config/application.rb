$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

# Find environment
RACK_ENV = ENV['RACK_ENV'] || 'development' unless defined? RACK_ENV

# Load db config and establish connection
ActiveRecord::Base.establish_connection YAML.load(File.read(File.join(File.dirname(__FILE__), '..', 'db', 'config.yml'))).with_indifferent_access[RACK_ENV]

# Setup logger for activerecord
ActiveRecord::Base.logger = Logger.new(File.open(File.join(File.dirname(__FILE__), '..', 'log', "#{RACK_ENV}.log"), 'a'))


Dir[File.expand_path('../../app/models/*.rb', __FILE__)].each do |f|
  require f
end

Dir[File.expand_path('../../api/*.rb', __FILE__)].each do |f|
  require f
end

require 'api'
require 'account_app'
