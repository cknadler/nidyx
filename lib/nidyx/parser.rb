require "nidyx/common"
require "nidyx/parse_constants"
require "nidyx/property"
require "nidyx/pointer"
require "nidyx/model"

include Nidyx::Common
include Nidyx::ParseConstants

module Nidyx
  module Parser
    extend self

    class UnsupportedSchemaError < StandardError; end

    # @param model_prefix [String] the prefix for model names
    # @param schema [Hash] JSON Schema
    # @param options [Hash] global application options
    # @return [Hash] a Hash of ModelData objects
    def parse(model_prefix, schema, options)
      # setup parser
      @class_prefix = model_prefix
      @options = options
      @schema = schema
      @models = {}

      # run model generation
      generate([], class_name(@class_prefix, nil))
      @models
    end

    private

    # Generates a Model and adds it to the models array.
    # @param path [Array] the path to an object in the schema
    # @param name [String] raw model name
    def generate(path, name)
      object = get_object(path)

      type = object[TYPE_KEY]
      if type == OBJECT_TYPE
        generate_object(path, name)

      elsif type == ARRAY_TYPE
        generate_top_level_array(path)

      elsif type.is_a?(Array)
        if type.include?(OBJECT_TYPE)
          raise UnsupportedSchemaError if type.include?(ARRAY_TYPE)
          generate_object(path, name)

        elsif type.include?(ARRAY_TYPE)
          generate_top_leve_array(path)

        else raise UnsupportedSchemaError; end
      else raise UnsupportedSchemaError; end
    end

    def generate_object(path, name)
      @models[name] = model = Nidyx::Model.new(name)
      required_properties = get_object(path)[REQUIRED_KEY]
      properties_path = path + [PROPERTIES_KEY]

      get_object(properties_path).keys.each do |key|
        optional = is_optional?(key, required_properties)
        property_path = properties_path + [key]
        model.properties << generate_property(key, property_path, model, optional)
      end
    end

    def generate_top_level_array(path)
      resolve_array_refs(get_object(path))
    end

    # @param key [String] the key of the property in the JSON Schema
    # @param path [Array] the path to the aforementioned object in the schema
    # @param model [Property] the model that owns the property to be generated
    # @param optional [Boolean] true if the property can be empty or null
    def generate_property(key, path, model, optional)
      obj = resolve_reference(path)
      class_name = obj[DERIVED_NAME]
      mapper = @options[:objc][:mapper] if @options[:objc]

      if include_type?(obj, OBJECT_TYPE) && obj[PROPERTIES_KEY]
        model.dependencies << class_name
      elsif include_type?(obj, ARRAY_TYPE)
        obj[COLLECTION_TYPES_KEY] = resolve_array_refs(obj)
        model.dependencies += obj[COLLECTION_TYPES_KEY]
      end

      name = obj[NAME_OVERRIDE_KEY] || key
      property = Nidyx::Property.new(name, class_name, optional, obj)
      if (mapper == "JSONModel")
        property.overriden_name = key if obj[NAME_OVERRIDE_KEY]
      elsif (mapper == "Mantle")
        # The 2.0 release of Mantle will want all keys definied, even if they are not overriden.
        property.overriden_name = key
      end
      property
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
    # it's parents.
    def resolve_reference(path, parent = nil)
      obj = get_object(path)
      ref = obj[REF_KEY]

      # TODO: merge parent and obj into obj (destructive)

      # If we find an immediate reference, chase it and pass the immediate
      # object as a parent.
      return resolve_reference_string(ref) if ref

      # If we are dealing with an object, encode it's class name into the
      # schema and generate it's model if necessary.
      if include_type?(obj, OBJECT_TYPE) && obj[PROPERTIES_KEY]
        obj[DERIVED_NAME] = class_name_from_path(@class_prefix, path, @schema)
        generate(path, obj[DERIVED_NAME]) unless @models.has_key?(obj[DERIVED_NAME])
      end

      obj
    end

    # Resolves any references burried in the `items` property of an array
    # definition. Returns a list of collection types in the array.
    # @param obj [Hash] the array property schema
    # @return [Array] list of types in the array
    def resolve_array_refs(obj)
      items = obj[ITEMS_KEY]
      types = []

      case items
      when Array
        items.each do |i|
          resolve_reference_string(i[REF_KEY])
          types << class_name_from_ref(i[REF_KEY])
        end
      when Hash
        resolve_reference_string(items[REF_KEY])
        types << class_name_from_ref(items[REF_KEY])
      end

      types.compact
    end

    def class_name_from_ref(ref)
      class_name_from_path(@class_prefix, Nidyx::Pointer.new(ref).path, @schema) if ref
    end

    # Resolves a reference as a plain JSON Pointer string.
    # @param ref [String] reference in json pointer format
    # @return [Hash] a modified schema object with inherited attributes from
    # it's parents.
    def resolve_reference_string(ref)
      resolve_reference(Nidyx::Pointer.new(ref).path) if ref
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
    def include_type?(obj, type)
      type_obj = obj[TYPE_KEY]
      type_obj.is_a?(Array) ? type_obj.include?(type) : type_obj == type
    end
  end
end
