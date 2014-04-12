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
        klass = build_class(class_name)
        build_resources(klass, resources)
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

    def build_table(class_name)
      table_name = class_name.to_s.underscore.pluralize
      unless connection.table_exists?(table_name)
        connection.create_table table_name, id: false
      end
    end

    def build_class(class_name)
      if Vend::Sync.const_defined?(class_name)
        Vend::Sync.const_get(class_name)
      else
        build_table(class_name)
        klass = Vend::Sync.const_set class_name, Class.new(ActiveRecord::Base)
        klass.inheritance_column = :_type_disabled
        klass
      end
    end

    def build_column(klass, key, value)
      unless klass.column_names.include?(key)
        type = case value
        when Integer
          :integer
        when TrueClass, FalseClass
          :boolean
        else
          :text 
        end
        connection.add_column(klass.table_name, key, type)
        klass.reset_column_information
      end
    end

    def build_resources(klass, resources)
      self.imports = {}
      resources.each do |resource|
        build_resource(klass, resource.attrs)
      end
      imports.each do |klass, models|
        klass.import models
      end
    end

    def build_resource(klass, attrs)
      attributes = {}
      attrs.each do |key, value|
        case value
        when Array
          value.each do |v|
            build_resource(child_class(key), v.merge(foreign_key(klass, attrs)))
          end
        when Hash
          value.each do |k, v|
            build_column(klass, "#{key}_#{k}", v)
            attributes["#{key}_#{k}"] = v
          end
        else
          build_column(klass, key, value)
          attributes[key] = value
        end
      end
      imports[klass] ||= []
      imports[klass] << klass.new(attributes)
    end

    def child_class(key)
      build_class(key.singularize.camelcase)
    end

    def foreign_key(klass, attrs)
      {klass.to_s.demodulize.underscore + '_id' => attrs['id']}
    end
  end
end