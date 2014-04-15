module Vend::Sync
  class Import
    attr_accessor :client, :imports

    delegate :connection, to: 'ActiveRecord::Base'

    def initialize(address, username, password)
      build_client(address, username, password)
    end

    def import(class_names = all_class_names)
      Array.wrap(class_names).each do |class_name|
        resources = client.send(class_name).all
        build_resources(class_name, resources)
      end
    end

    private

    def build_client(address, username, password)
      @client = Vend::Client.new(address, username, password)
    end

    def all_class_names
      [
        :Outlet, :Product, :Customer, :PaymentType, :Register, :RegisterSale,
        :Tax, :User
      ]
    end

    def build_table_name(class_name)
      class_name.to_s.underscore.pluralize
    end

    def build_table(table_name, records)
      unless connection.table_exists?(table_name)
        connection.create_table table_name, id: false
      end
      records.each do |attributes|
        attributes.each do |key, value|
          build_column(table_name, key, value)
        end
      end
    end

    def build_column(table_name, key, value)
      unless connection.column_exists?(table_name, key)
        connection.add_column(table_name, key, column_type(key, value))
        if key == 'id'
          connection.add_index(table_name, key, unique: true)
        elsif key.ends_with?('_id')
          connection.add_index(table_name, key)
        end
      end
    end

    def column_type(key, value)
      if key == 'id' or key.ends_with?('_id')
        :string
      elsif key.ends_with?('_at')
        :datetime
      else
        case value
        when Integer
          :decimal
        when TrueClass, FalseClass
          :boolean
        else
          :text
        end
      end
    end

    def build_resources(class_name, resources)
      self.imports = {}
      table_name = build_table_name(class_name)
      resources.each do |resource|
        build_resource(table_name, resource.attrs)
      end
      imports.each do |table_name, records|
        build_table(table_name, records)
        Upsert.batch(connection, table_name) do |upsert|
          records.each do |attributes|
            upsert.row(attributes.slice('id'), attributes.slice!('id'))
          end
        end
      end
    end

    def build_resource(table_name, attrs)
      if id = attrs['id']
        attributes = {}
        attrs.each do |key, value|
          key = key + '_' if key.ends_with?('_set')
          case value
          when Array
            value.each do |v|
              build_resource(key, v.merge(foreign_key(table_name, id)))
            end
          when Hash
            build_resource(key.pluralize, value)
            attributes[key + '_id'] = value['id']
          else
            attributes[key] = value if value.present?
          end
        end
        imports[table_name] ||= []
        imports[table_name] << attributes
      else
        # puts "skipping composite key #{table_name}: #{attrs.keys.join(', ')}"
      end
    end

    def foreign_key(table_name, id)
      {table_name.singularize + '_id' => id}
    end
  end
end