require "set"

module Nidyx
  class ObjCProperty
    attr_reader :name, :attributes, :type, :type_name, :desc, :getter_override,
                :protocols

    class UnsupportedEnumTypeError < StandardError; end

    # @param property [Property] generic property
    def initialize(property)
      @name = property.name
      @optional = property.optional
      @desc = property.description

      @getter_override = process_getter_override(name)
      @type = process_type(property)
      @attributes = ATTRIBUTES[@type]
      @type_name = lookup_type_name(@type, property.class_name)

      @protocols = []
      @protocols += property.collection_types if property.collection_types
      @protocols << "Optional" if @optional
    end

    # @return [Boolean] true if the obj-c property type is an object
    def is_obj?
      OBJECTS.include?(self.type)
    end

    # @return [Boolean] true if the property has protocols
    def has_protocols?
      !@protocols.empty?
    end

    # @return [String] the property's protocols, comma separated
    def protocols_string
      @protocols.join(", ")
    end

    private

    PRIMITIVE_ATTRIBUTES = "assign, nonatomic"
    OBJECT_ATTRIBUTES = "strong, nonatomic"

    ATTRIBUTES = {
      :array      => OBJECT_ATTRIBUTES,
      :boolean    => PRIMITIVE_ATTRIBUTES,
      :integer    => PRIMITIVE_ATTRIBUTES,
      :number     => PRIMITIVE_ATTRIBUTES,
      :number_obj => OBJECT_ATTRIBUTES,
      :string     => OBJECT_ATTRIBUTES,
      :object     => OBJECT_ATTRIBUTES,
      :id         => OBJECT_ATTRIBUTES
    }

    # Objective-C types
    # :object intentionally omitted
    TYPES = {
      :array      => "NSArray",
      :boolean    => "BOOL",
      :integer    => "NSInteger",
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

    OBJECTS = Set.new [:array, :number_obj, :string, :object, :id]

    SIMPLE_NUMBERS = Set.new [:integer, :number]

    BOXABLE_NUMBERS = SIMPLE_NUMBERS + [:boolean]

    FORBIDDEN_PROPERTY_PREFIXES = ["new", "copy"]

    # @param type [Symbol] an obj-c property type
    # @param class_name [String] an object's type name
    # @return [String] the property's type name
    def lookup_type_name(type, class_name)
      type == :object ? class_name : TYPES[type]
    end

    # @param property [Property] generic property
    # @return [Symbol] an obj-c property type
    def process_type(property)
      return process_enum_type(property) if property.enum

      type = property.type
      if type.is_a?(Set)
        process_array_type(type, property)
      else
        process_simple_type(type, property)
      end
    end


    # @param property [Property] generic property
    # @return [Symbol] an obj-c property type
    def process_enum_type(property)
      enum = property.enum

      # map enum to a set of types
      types = enum.map { |a| a.class }
      raise UnsupportedEnumTypeError unless (types & [ Array, Hash ]).empty?
      types = Set.new(types.map { |t| ENUM_TYPES[t] })

      process_array_type(types, property)
    end

    # @param type [Symbol] a property type string
    # @param property [Property] generic property
    # @return [Symbol] an obj-c property type
    def process_simple_type(type, property)
      case type
      when :boolean, :number, :integer
        @optional ? :number_obj : type

      when :null
        @optional = true
        :id

      when :object
        property.has_properties? ? :object : :id

      else
        type
      end
    end

    # @param type [Set] an array of property types
    # @param property [Property] generic property
    # @return [Symbol] an obj-c property type
    def process_array_type(types, property)
      # if the key is optional
      @optional = true if types.delete?(:null)

      # single optional type
      return process_simple_type(types.to_a.shift, property) if types.size == 1

      # conjoined number types
      return :number if types.subset?(SIMPLE_NUMBERS) && !@optional
      return :number_obj if types.subset?(BOXABLE_NUMBERS)

      :id
    end

    # @param name [String] the property name
    # @return [String, nil] the getter override string if necessary
    def process_getter_override(name)
      FORBIDDEN_PROPERTY_PREFIXES.each do |p|
        return ", getter=get#{name.camelize}" if name.match(/^#{p}[_A-Z].*/)
      end

      nil
    end
  end
end
