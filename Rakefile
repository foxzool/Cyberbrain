require 'rubygems'
require 'bundler'

Bundler.setup(:default, :development)

require 'rake'

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require File.expand_path('../config/environment', __FILE__)
end

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/api/*_spec.rb']
end

require 'active_record_migrations'
ActiveRecordMigrations.configure do |config|
  config.yaml_config = 'db/database.yml'
end
ActiveRecordMigrations.load_tasks

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: [:rubocop, :spec]
