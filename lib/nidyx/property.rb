require "set"

module Nidyx
  class Property
    attr_reader :name, :attributes, :type, :type_name,
      :desc, :optional, :getter_override

    class UndefinedTypeError < StandardError; end
    class NonArrayEnumError < StandardError; end
    class EmptyEnumError < StandardError; end
    class UnsupportedEnumTypeError < StandardError; end

    # @param name [String] property name
    # @param class_name [String] class name, only for object properties
    # @param obj [Hash] the property object in schema format
    # @param optional [Boolean] true if the property can be null or empty
    def initialize(name, class_name, obj, optional)
      @name = name.camelize(false)
      @getter_override = process_getter_override(name)
      @optional = optional
      @type = process_json_type(obj)
      @attributes = ATTRIBUTES[@type]
      @type_name = lookup_type_name(@type, class_name)
      @desc = obj["description"]
    end

    # @return [Boolean] true if the obj-c property type is an object
    def is_obj?
      OBJECTS.include?(self.type)
    end

    private

    PRIMITIVE_ATTRIBUTES = "assign, nonatomic"
    OBJECT_ATTRIBUTES = "strong, nonatomic"

    ATTRIBUTES = {
      :array      => OBJECT_ATTRIBUTES,
      :boolean    => PRIMITIVE_ATTRIBUTES,
      :integer    => PRIMITIVE_ATTRIBUTES,
      :unsigned   => PRIMITIVE_ATTRIBUTES,
      :number     => PRIMITIVE_ATTRIBUTES,
      :number_obj => OBJECT_ATTRIBUTES,
      :string     => OBJECT_ATTRIBUTES,
      :object     => OBJECT_ATTRIBUTES,
      :id         => OBJECT_ATTRIBUTES
    }

    # :object intentionally omitted
    TYPES = {
      :array      => "NSArray",
      :boolean    => "BOOL",
      :integer    => "NSInteger",
      :unsigned   => "NSUInteger",
      :number     => "double",
      :number_obj => "NSNumber",
      :string     => "NSString",
      :id         => "id"
    }

    # Hash and Array intentionally omitted
    ENUM_TYPES = {
      Fixnum     => :integer,
      String     => :string,
      NilClass   => :null,
      Float      => :number,
      TrueClass  => :boolean,
      FalseClass => :boolean
    }


    OBJECTS = Set.new [ :array, :number_obj, :string, :object, :id ]

    SIMPLE_NUMBERS = Set.new [ :integer, :number ]

    BOXABLE_NUMBERS = Set.new SIMPLE_NUMBERS + [ :boolean ]

    FORBIDDEN_PROPERTY_PREFIXES = [ "new", "copy" ]

    # @param type [Symbol] an obj-c property type
    # @param class_name [String] an object's type name
    # @return [String] the property's type name
    def lookup_type_name(type, class_name)
      type == :object ? class_name : TYPES[type]
    end

    # @param obj [Hash] the property object in schema format
    # @return [Symbol] an obj-c property type
    def process_json_type(obj)
      enum = obj["enum"]
      return process_enum_type(enum, obj) if enum

      type = obj["type"]
      if type.is_a?(Array)
        raise UndefinedTypeError if !type || type.empty?
        types = Set.new(type_array_to_sym(type))
        process_array_type(types, obj)
      else
        raise UndefinedTypeError unless type
        process_simple_type(type.to_sym, obj)
      end
    end

    # @param array [Array] an array of strings
    # @return an array of symbols
    def type_array_to_sym(array)
      array.map { |i| i.to_sym }
    end

    # @param enum [Array] an array of possible property values
    # @param obj [Hash] the property object in schema format
    # @return [Symbol] an obj-c property type
    def process_enum_type(enum, obj)
      # type checks
      raise NonArrayEnumError unless enum.is_a?(Array)
      raise EmptyEnumError if enum.empty?

      # map enum to a set of types
      types = enum.map { |a| a.class }.uniq
      raise UnsupportedEnumTypeError unless (types & [ Array, Hash ]).empty?
      types = Set.new(types.map { |t| ENUM_TYPES[t] })

      process_array_type(types, obj)
    end

    # @param type [Symbol] a property type string
    # @param obj [Hash] the property object in schema format
    # @return [Symbol] an obj-c property type
    def process_simple_type(type, obj)
      case type
      when :boolean, :number
        self.optional ? :number_obj : type

      when :integer
        return :number_obj if self.optional
        (obj["minimum"] && obj["minimum"] >= 0) ? :unsigned : :integer

      when :null
        @optional = true
        :id

      when :object
        obj["properties"] ? :object : :id

      else
        type
      end
    end

    # @param type [Set] an array of property types
    # @param obj [Hash] the property object in schema format
    # @return [Symbol] an obj-c property type
    def process_array_type(type, obj)
      # if the key is optional
      if type.include?(:null)
        @optional = true
        type -= [:null]
      end

      # single optional type
      return process_simple_type(type.to_a.shift, obj) if type.size == 1

      # conjoined number types
      return :number if type.subset?(SIMPLE_NUMBERS) && !@optional
      return :number_obj if type.subset?(BOXABLE_NUMBERS)

      :id
    end

    # @param name [String] the property name
    # @return [String, nil] the getter override string if necessary
    def process_getter_override(name)
      FORBIDDEN_PROPERTY_PREFIXES.each do |p|
        return ", get#{name.camelize}" if name.match(/^#{p}.*/)
      end

      nil
    end
  end
end
