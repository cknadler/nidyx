require "nidyx/common"
require "nidyx/model_h"
require "nidyx/model_m"
require "nidyx/property"

include Nidyx::Common

class EmptySchemaError < StandardError; end

module Nidyx
  class Generator
    attr_accessor :class_prefix, :options

    def initialize(class_prefix, options)
      @class_prefix = class_prefix
      @options = options
    end

    def spawn(schema)
      raise EmptySchemaError if empty_schema?(schema)

      models = {}
      generate_model([], nil, schema, models)
      models
    end

    private

    # @param path [Hash] the path in the schema of the model to be generated
    # @param raw_name [String] the model's unformatted name, optional
    # @param schema [Hash] the full schema (for definition lookup)
    # @param models [Hash] a hash containing all of the generated models
    # (for model lookup)
    def generate_model(path, raw_name, schema, models)
      name = class_name(self.class_prefix, raw_name)
      models[name] = {}
      path << "properties"
      generate_h(path, name, schema, models)
      generate_m(name, models)
    end

    def generate_h(path, name, schema, models)
      model = Nidyx::ModelH.new(name, self.options)

      object_at_path(schema, path).each do |k, v|
        property_path = path + [k]
        model.properties[k] = generate_property(k, v, property_path, model, models, schema)
      end

      models[name][:h] = model
    end

    def generate_property(name, value, path, model, models, schema)
      type = value["type"]
      desc = value["description"]
      class_name = nil

      if type == "object"
        class_name = class_name_from_path(path)
      end

      Nidyx::Property.new(name, type, class_name, desc)
    end

    def generate_m(name, models)
      models[name][:m] = Nidyx::ModelM.new(name, self.options)
    end

    def empty_schema?(schema)
      props = schema["properties"]
      props == nil || props.empty?
    end

    def object_at_path(schema, path)
      obj = schema
      path.each { |p| obj = obj[p] }
      obj
    end

    def class_name_from_path(path)
      name = ""
      path.each { |p| name += p.camelize if p != "properties" }
      self.class_prefix + name + "Model"
    end
  end
end
