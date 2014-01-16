require "set"

module Nidyx
  class Property
    attr_reader :name, :class_name, :optional, :type, :description, :enum,
      :minimum, :collection_types

    class UndefinedTypeError < StandardError; end
    class NonArrayEnumError < StandardError; end
    class EmptyEnumError < StandardError; end

    def initialize(name, class_name, optional, obj)
      @name = name.camelize(false)
      @class_name = class_name
      @optional = optional
      @enum = obj["enum"]
      @type = process_type(obj["type"], @enum)
      @description = obj["description"]
      @minimum = obj["minimum"]
      @properties = obj["properties"]
      @collection_types = obj["collectionTypes"]
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
