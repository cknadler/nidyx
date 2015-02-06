require "set"
require "nidyx/parse_constants"

include Nidyx::ParseConstants

module Nidyx
  class Property
    attr_accessor :overriden_name
    attr_reader :name, :class_name, :optional, :type, :description, :enum,
      :collection_types, :minimum

    class UndefinedTypeError < StandardError; end
    class NonArrayEnumError < StandardError; end
    class EmptyEnumError < StandardError; end

    def initialize(name, class_name, optional, obj)
      @name = name.camelize(false)
      @class_name = class_name
      @optional = optional
      @enum = obj[ENUM_KEY]
      @type = process_type(obj[TYPE_KEY], @enum)
      @description = obj[DESCRIPTION_KEY]
      @properties = obj[PROPERTIES_KEY]
      @collection_types = obj[COLLECTION_TYPES_KEY]
      @minimum = obj[MINIMUM_KEY]
    end

    def has_properties?
      !!@properties
    end

    private

    def process_type(type, enum)
      if enum
        raise NonArrayEnumError unless @enum.is_a?(Array)
        raise EmptyEnumError if @enum.empty?
        return
      end

      case type
      when Array
        raise UndefinedTypeError if type.empty?
        Set.new(type.map { |t| t.to_sym })
      when String
        type.to_sym
      else
        raise UndefinedTypeError
      end
    end
  end
end
