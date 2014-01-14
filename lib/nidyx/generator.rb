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

    # Generates Nidyx::ModelH and Nidyx::ModelM pairs from JSON Schema. Models
    # are returned in the following format:
    #
    #   {
    #     "ModelName" => {
    #       :h => ModelH,
    #       :m => ModelM
    #     },
    #     ...
    #   }
    #
    # @param class_prefix [String] the prefix string for generated classes
    # @param options [Hash] global application options
    # @param schema [Hash] base JSON Schema
    # @return [Hash] a Hash of models in the following format:
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
    CLASS_NAME_KEY = "className"

    # Generate a ModelH / ModelM pair.
    # @param path [Hash] the path in the schema of the model to be generated
    # @param name [String] the model's name (for model lookup)
    def generate_model(path, name)
      @models[name] = {}
      generate_h(path, name)
      generate_m(name)
    end

    # Generates a ModelH and adds it to the models array.
    # @param path [Array] the path to an object in the schema
    # @param name [String] raw model name
    def generate_h(path, name)
      model = Nidyx::ModelH.new(name, @options)
      required_properties = get_object(path)["required"]
      properties_path = path + ["properties"]

      get_object(properties_path).each do |key, obj|
        optional = is_optional?(key, required_properties)
        property_path = properties_path + [key]
        model.properties << generate_property(key, property_path, model, optional)
      end

      @models[name][:h] = model
    end

    # Generates a ModelM and adds it to the models array.
    # @param name [String] raw model name
    def generate_m(name)
      @models[name][:m] = Nidyx::ModelM.new(name, @options)
    end

    # @param key [String] the key of the property in the JSON Schema
    # @param path [Array] the path to the aforementioned object in the schema
    # @param model [Property] the model that owns the property to be generated
    # @param optional [Boolean] true if the property can be empty or null
    def generate_property(key, path, model, optional)
      obj = resolve_reference(path)
      type = obj["type"]
      class_name = obj[CLASS_NAME_KEY]

      if include_type?(type, "object") && obj["properties"]
        model.imports << class_name unless model.imports.include?(class_name)
      elsif include_type?(type, "array")
        resolve_array_refs(obj)
      end

      Nidyx::Property.new(key, class_name, obj, optional)
    end

    # Given a path, which could be at any part of a reference chain, resolve
    # the immediate schema object. This means:
    #
    # - if there is an imediate ref, follow it
    # - inherit any schema information from the parent reference chain
    # (unimplemented)
    #
    # If we are at the end of a chain, do the following:
    #
    # - generate a model for this object if necessary
    # - add `class_name` to the immediate object when appropriate
    # - return the immediate object
    #
    # @param path [Array] the path to an object in the schema
    # @param parent [Hash, nil] the merged attributes of the parent reference chain
    # @return [Hash] a modified schema object with inherited attributes from
    # it's parents and an optional key `class_name`.
    def resolve_reference(path, parent = nil)
      obj = get_object(path)
      ref = obj[REF_KEY]

      # TODO: merge parent and obj into obj (destructive)

      # If we find an immediate reference, chase it and pass the immediate
      # object as a parent.
      return resolve_reference_string(ref) if ref

      # If we are dealing with an object, encode it's class name into the
      # schema and generate it's model if necessary.
      if include_type?(obj["type"], "object") && obj["properties"]
        class_name = class_name_from_path(@class_prefix, path)
        obj[CLASS_NAME_KEY] = class_name_from_path(@class_prefix, path)
        generate_model(path, class_name) unless @models.include?(class_name)
      end

      obj
    end

    # Resolves any references burried in the `items` property of an array
    # definition.
    # @param obj [Hash] the array property schema
    def resolve_array_refs(obj)
      items = obj["items"]
      case items
      when Array
        items.each { |i| resolve_reference_string(i[REF_KEY]) }
      when Hash
        resolve_reference_string(items[REF_KEY])
      end
    end

    # Resolves a reference as a plain JSON Pointer string.
    # @param ref [String] reference in json pointer format
    # @return [Hash] a modified schema object with inherited attributes from
    # it's parents and an optional key `class_name`.
    def resolve_reference_string(ref)
      resolve_reference(Nidyx::Pointer.new(ref).path) if ref
    end

    # @param schema [Hash] an object containing JSON schema
    # @return [Boolean] true if the schema is empty
    def empty_schema?(schema)
      props = schema["properties"]
      props == nil || props.empty?
    end

    # @param path [Array] the path to an object in the global schema
    # @return [Hash] a object containing JSON schema
    def get_object(path)
      object_at_path(path, @schema)
    end

    # @param key [String] the id of a specific property
    # @param required_keys [Array] an array of the required property keys
    # @return true if the property is optional
    def is_optional?(key, required_keys)
      !(required_keys && required_keys.include?(key))
    end

    # @param type_obj [Array, String] the JSON Schema type
    # @param type [String] a string type to test
    # @param true if the string type is a valid type according type object
    def include_type?(type_obj, type)
      type_obj.is_a?(Array) ? type_obj.include?(type) : type_obj == type
    end
  end
end
