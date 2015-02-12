$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

# Find environment
RACK_ENV = ENV['RACK_ENV'] || 'development' unless defined? RACK_ENV

# Load db config and establish connection
database_file = File.read(File.join(File.dirname(__FILE__), '..', 'db', 'database.yml'))
ActiveRecord::Base.establish_connection YAML.load(database_file).with_indifferent_access[RACK_ENV]

# Setup logger for activerecord
log_file = File.open(File.join(File.dirname(__FILE__), '..', 'log', "#{RACK_ENV}.log"), 'a')
ActiveRecord::Base.logger = Logger.new(log_file)

Dir[File.expand_path('../../app/models/*.rb', __FILE__)].each do |f|
  require f
end

Dir[File.expand_path('../../api/*.rb', __FILE__)].each do |f|
  require f
end

require 'api'
require 'account_app'
