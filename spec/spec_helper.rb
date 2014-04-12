require 'bundler/setup'
require 'rspec'
require 'webmock/rspec'
require 'database_cleaner'
require 'vend/sync'

WebMock.disable_net_connect!(allow_localhost: true)

Vend::Sync::Database.connect('vend_sync_test')

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end