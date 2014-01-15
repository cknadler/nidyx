require "set"

module Nidyx
  class Property

    class UndefinedTypeError < StandardError; end
    class NonArrayEnumError < StandardError; end
    class EmptyEnumError < StandardError; end

    attr_reader :name, :class_name, :type, :description, :enum,
      :minimum, :maximum, :optional

    def initialize(name, class_name, optional, obj)
      @name = name.camelize(false)
      @class_name = class_name
      @optional = optional
      @type = process_type(obj["type"])
      @minimum = obj["minimum"]
      @maximum = obj["maximum"]
      @properties = obj["properties"]

      # type checks
      raise NonArrayEnumError unless @enum.is_a?(Array)
      raise EmptyEnumError if @enum.empty?
    end

    def has_properties?
      !!@properties
    end

    private

    def process_type(type)
      if type.is_a?(Array)
        raise UndefinedTypeError if type.empty?
        Set.new(array_to_sym(type))
      else
        raise UndefinedTypeError unless type
        type.to_sym
      end
    end

    # @param array [Array] an array of strings
    # @return an array of symbols
    def array_to_sym(array)
      array.map { |i| i.to_sym }
    end
  end
end
