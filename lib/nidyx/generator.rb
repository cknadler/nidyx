require "nidyx/common"
require "nidyx/model_h"
require "nidyx/model_m"
require "nidyx/property"
require "nidyx/pointer"

include Nidyx::Common

class EmptySchemaError < StandardError; end

module Nidyx
  module Generator
    extend self

    def spawn(class_prefix, options, schema)
      @class_prefix = class_prefix
      @options = options
      raise EmptySchemaError if empty_schema?(schema)
      @schema = schema
      @models = {}
      generate_model([], class_name(@class_prefix, nil))
      @models
    end

    private

    REF_KEY = "$ref"

    # @param path [Hash] the path in the schema of the model to be generated
    # @param name [String] the model's name
    # (for model lookup)
    def generate_model(path, name)
      @models[name] = {}
      generate_h(path + ["properties"], name)
      generate_m(name)
    end

    def generate_h(path, name)
      model = Nidyx::ModelH.new(name, @options)

      properties = object_at_path(path, @schema)
      properties.each do |k, v|
        generate_property(k, v, path + [k], model)
      end

      @models[name][:h] = model
    end

    def generate_property(name, value, path, model)
      class_name = nil

      # if property is a reference
      if value[REF_KEY]
        path = Nidyx::Pointer.new(value[REF_KEY]).path
        value = object_at_path(path, @schema)
      end

      # if property is an object
      if value["type"] == "object"
        class_name = class_name_from_path(@class_prefix, path)
        model.imports << class_name
        generate_model(path, class_name) unless @models.include?(class_name)
      end

      model.properties << Nidyx::Property.new(name, class_name, value)
    end

    def generate_m(name)
      @models[name][:m] = Nidyx::ModelM.new(name, @options)
    end

    def empty_schema?(schema)
      props = schema["properties"]
      props == nil || props.empty?
    end
  end
end
