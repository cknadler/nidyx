require "nidyx/common"
require "nidyx/model_h"
require "nidyx/model_m"
require "nidyx/property"
require "nidyx/pointer"
require "pry"

include Nidyx::Common

class EmptySchemaError < StandardError; end

module Nidyx
  class Generator
    attr_accessor :class_prefix, :options

    REF_KEY = "$ref"

    def initialize(class_prefix, options)
      @class_prefix = class_prefix
      @options = options
    end

    def spawn(schema)
      raise EmptySchemaError if empty_schema?(schema)

      models = {}
      generate_model([], class_name(self.class_prefix, nil), schema, models)
      models
    end

    private

    # @param path [Hash] the path in the schema of the model to be generated
    # @param name [String] the model's name
    # @param schema [Hash] the full schema (for definition lookup)
    # @param models [Hash] a hash containing all of the generated models
    # (for model lookup)
    def generate_model(path, name, schema, models)
      models[name] = {}
      generate_h(path + ["properties"], name, schema, models)
      generate_m(name, models)
    end

    def generate_h(path, name, schema, models)
      model = Nidyx::ModelH.new(name, self.options)

      properties = object_at_path(path, schema)
      properties.each do |k, v|
        model.properties[k] = generate_property(k, v, path + [k], model, models, schema)
      end

      models[name][:h] = model
    end

    def generate_property(name, value, path, model, models, schema)
      # if property is a reference
      if value[REF_KEY]
        ptr = Nidyx::Pointer.new(value[REF_KEY])
        path = ptr.path
        binding.pry
        value = object_at_path(path, schema)
      end

      type = value["type"]
      desc = value["description"]
      class_name = nil

      if type == "object"
        class_name = class_name_from_path(self.class_prefix, path)
        model.imports << header_path(class_name)
        generate_model(path, class_name, schema, models) unless models.include?(class_name)
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
  end
end
