module Nidyx
  class Property
    attr_reader :name, :attributes, :type, :typename, :desc, :optional

    # @param name [String] property name
    # @param class_name [String] class name, only for object properties
    # @param obj [Hash] the property object in schema format
    # @param optional [Boolean] true if the property can be null or empty
    def initialize(name, class_name, obj, optional)
      @name = name
      @optional = optional
      @type = process_json_type(obj)
      @attributes = ATTRIBUTES[@type]
      @typename = type_name(@type, class_name)
      @desc = obj["description"]
    end

    def is_object?
      OBJECTS.include?(self.type)
    end

    private

    ATTRIBUTES = {
      :array      => "(strong, nonatomic)",
      :boolean    => "(assign, nonatomic)",
      :integer    => "(assign, nonatomic)",
      :unsigned   => "(assign, nonatomic)",
      :number     => "(nonatomic)",
      :number_obj => "(strong, nonatomic)",
      :string     => "(strong, nonatomic)",
      :object     => "(strong, nonatomic)",
      :id         => "(strong, nonatomic)"
    }

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

    OBJECTS = [:array, :number_obj, :string, :object, :id]

    NUMBERS = [:boolean, :integer, :number]

    # @param obj [Hash] the property object in schema format
    def process_json_type(obj)
      type = obj["type"]

      case type
      when Array
        return process_array_type(type, obj)

      when "boolean", "number"
        return self.optional ? :number : type.to_sym

      when "integer"
        return :number if self.optional
        (obj["minimum"] && obj["minimum"] >= 0) ? :unsigned : :integer

      when "null"
        return :id

      else
        return type.to_sym
      end
    end

    # @param type [Array] an array of types of a specific property
    # @param obj [Hash] the property object in schema format
    def process_array_type(type, obj)

    end

    def type_name(type, class_name)
      type == :object ? class_name : TYPES[type]
    end
  end
end
