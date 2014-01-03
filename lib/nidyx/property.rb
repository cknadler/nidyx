module Nidyx
  class Property
    attr_reader :name, :attributes, :type, :desc

    # @param name [String] property name
    # @param type [String] the property's JSON Schema type
    # @param class_name [String] class name, only for object properties
    # @param desc [String] optional description
    def initialize(name, type, class_name, desc)
      @name = name
      @attributes = ATTRIBUTES[type]
      @type = get_type(type, class_name)
      @desc = desc
    end

    private

    ATTRIBUTES = {
      "array" => "(strong, nonatomic)",
      "boolean" => "(assign, nonatomic)",
      "integer" => "(assign, nonatomic)",
      "number" => "(nonatomic)",
      "object" => "(strong, nonatomic)",
      "string" => "(strong, nonatomic)"
    }

    TYPES = {
      "array" => "NSArray *",
      "boolean" => "BOOL ",
      "integer" => "NSInteger ",
      "number" => "double ",
      "string" => "NSString *"
    }

    def get_type(type, class_name)
      type == "object" ? "#{class_name} *" : TYPES[type]
    end
  end
end
