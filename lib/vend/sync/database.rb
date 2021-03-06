require 'yaml'

module Vend::Sync
  module Database
    def self.connect(database = connection_params['database'])
      ActiveRecord::Base.establish_connection(
        connection_params.merge(database: 'postgres')
      )
      database_names = ActiveRecord::Base.connection.select_values(
        'SELECT datname FROM pg_database'
      )
      unless database_names.include?(database)
        ActiveRecord::Base.connection.create_database(database)
      end
      ActiveRecord::Base.establish_connection(
        connection_params.merge(database: database)
      )
    end

    def self.drop(database = connection_params['database'])
      ActiveRecord::Base.establish_connection(
        connection_params.merge(database: 'postgres')
      )
      database_names = ActiveRecord::Base.connection.select_values(
        'SELECT datname FROM pg_database'
      )
      if database_names.include?(database)
        ActiveRecord::Base.connection.drop_database(database)
      end
    end

    private

    def self.connection_params
      YAML.load_file( File.dirname(__FILE__) + '/../../../config/database.yml' )
    end

  end
end
