require "set"

module Nidyx
  class Property
    attr_reader :name, :class_name, :optional, :type, :description, :enum,
      :minimum

    class UndefinedTypeError < StandardError; end
    class NonArrayEnumError < StandardError; end
    class EmptyEnumError < StandardError; end

    def initialize(name, class_name, optional, obj)
      @name = name.camelize(false)
      @class_name = class_name
      @optional = optional
      @type = process_type(obj["type"])
      @description = obj["description"]
      @enum = obj["enum"]
      @minimum = obj["minimum"]
      @properties = obj["properties"]

      # type checks
      if @enum
        raise NonArrayEnumError unless @enum.is_a?(Array)
        raise EmptyEnumError if @enum.empty?
      end
    end

    def has_properties?
      !!@properties
    end

    private

    def process_type(type)
      if type.is_a?(Array)
        raise UndefinedTypeError if type.empty?
        Set.new(type.map { |t| t.to_sym })
      else
        raise UndefinedTypeError unless type
        type.to_sym
      end
    end
  end
end
