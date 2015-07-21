require 'fileutils'
require 'logger'
require 'sequel'
require 'pact_broker'
require 'delegate'

class DatabaseLogger < SimpleDelegator
  def info *args
    __getobj__().debug(*args)
  end
end

DATABASE_CREDENTIALS = {
  adapter: 'sqlite',
  pool: 5,
  timeout: 5000,
  database: ENV['PACT_BROKER_DATABASE_NAME']
}

app = PactBroker::App.new do | config |
  # change these from their default values if desired
  # config.log_dir = "./log"
  # config.auto_migrate_db = true
  # config.use_hal_browser = true
  config.logger = ::Logger.new($stdout)
  config.database_connection = Sequel.connect(DATABASE_CREDENTIALS.merge(logger: DatabaseLogger.new(config.logger), encoding: 'utf8'))
end

run app
