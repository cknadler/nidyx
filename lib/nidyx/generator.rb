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
    # @param name [String] the model's name (for model lookup)
    def generate_model(path, name)
      @models[name] = {}
      generate_h(path + ["properties"], name)
      generate_m(name)
    end

    def generate_h(path, name)
      model = Nidyx::ModelH.new(name, @options)

      object_at_path(path, @schema).each do |key, obj|
        generate_property(key, obj, path + [key], model)
      end

      @models[name][:h] = model
    end

    def generate_property(key, obj, path, model)
      class_name = nil

      # if property is a reference, resolve the object path
      if obj[REF_KEY]
        path = Nidyx::Pointer.new(obj[REF_KEY]).path
        obj = object_at_path(path, @schema)
      end

      # if property is an object
      if obj["type"] == "object"
        class_name = class_name_from_path(@class_prefix, path)
        model.imports << class_name
        generate_model(path, class_name) unless @models.include?(class_name)
      end

      model.properties << Nidyx::Property.new(key, class_name, obj)
    end

    def generate_m(key)
      @models[key][:m] = Nidyx::ModelM.new(key, @options)
    end

    def empty_schema?(schema)
      props = schema["properties"]
      props == nil || props.empty?
    end
  end
end
