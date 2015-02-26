#!/usr/bin/env rake
require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/api/*_spec.rb', 'spec/models/*_spec.rb', 'spec/policies/*_spec.rb']
end

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require File.expand_path('../config/environment', __FILE__)
end

task :routes => :environment do
  Cyberbrain::API::RootEndpoint.routes.each do |route|
    method      = route.route_method.ljust(10)
    path        = route.route_path.gsub(":version", route.route_version)
    description = route.route_description
    puts "     #{method} #{path}          #{description} "
  end
end

require 'active_record_migrations'
ActiveRecordMigrations.configure do |config|
  config.yaml_config = 'db/database.yml'
end
ActiveRecordMigrations.load_tasks

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: [:rubocop, :spec]
