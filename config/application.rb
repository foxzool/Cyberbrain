$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app', 'api'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

require 'cyberbrain'
require 'roar/representer'
require 'roar/json'
require 'roar/json/hal'
require 'roar/json/json_api'

require 'active_record'

# Load db config and establish connection
database_file = File.read(File.join(File.dirname(__FILE__), '..', 'db', 'database.yml'))
ActiveRecord::Base.establish_connection YAML.load(database_file).with_indifferent_access[ENV['RACK_ENV']]

# Setup logger for activerecord
log_file                  = File.open(File.join(File.dirname(__FILE__), '..', 'log', "#{ENV['RACK_ENV']}.log"), 'a')
ActiveRecord::Base.logger = Logger.new(log_file)

%w(helpers validators models/concerns models policies).each do |path|
  Dir[File.expand_path("../../app/#{path}/*.rb", __FILE__)].each do |f|
    require f
  end
end

require File.expand_path('../../app/cyberbrain_app.rb', __FILE__)
