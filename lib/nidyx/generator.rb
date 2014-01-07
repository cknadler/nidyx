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
      generate_h(path, name)
      generate_m(name)
    end

    def generate_h(path, name)
      model = Nidyx::ModelH.new(name, @options)
      required_properties = get_object(path)["required"]
      properties_path = path + ["properties"]

      get_object(properties_path).each do |key, obj|
        optional = is_optional?(key, required_properties)
        property_path = properties_path + [key]
        generate_property(key, property_path, model, optional)
      end

      @models[name][:h] = model
    end

    def generate_m(key)
      @models[key][:m] = Nidyx::ModelM.new(key, @options)
    end

    # @param key [String] the key of the property in the JSON Schema
    # @param path [Array] the path to the aforementioned object in the schema
    # @param model [Property] the model that owns the property to be generated
    # @param optional [Boolean] true if the property can be empty or null
    def generate_property(key, path, model, optional)
      class_name = nil

      path = resolve_refs(path)
      obj = get_object(path)

      # if property is an object
      if obj["type"] == "object"
        class_name = class_name_from_path(@class_prefix, path)
        model.imports << class_name
        generate_model(path, class_name) unless @models.include?(class_name)
      end

      model.properties << Nidyx::Property.new(key, class_name, obj, optional)
    end


    def resolve_refs(path)
      obj = get_object(path)
      return resolve_refs(Nidyx::Pointer.new(obj[REF_KEY]).path) if obj[REF_KEY]
      path
    end

    def empty_schema?(schema)
      props = schema["properties"]
      props == nil || props.empty?
    end

    def get_object(path)
      object_at_path(path, @schema)
    end

    def is_optional?(key, required_keys)
      !(required_keys && required_keys.include?(key))
    end
  end
end
