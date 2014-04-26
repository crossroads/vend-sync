require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'yaml'
require 'vend/sync'

task :default => ['spec']

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

desc "Sync database from Vend"
task :sync do
  creds = YAML.load_file( File.dirname(__FILE__) + '/config/vend.yml' )
  Vend::Sync::Database.connect
  Vend::Sync::Import.new(creds['account'], creds['username'], creds['password']).import
end
