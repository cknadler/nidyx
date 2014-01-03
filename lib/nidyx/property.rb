module Nidyx
  class Property
    attr_reader :name, :attributes, :type, :desc

    # @param name [String] property name
    # @param class_name [String] class name, only for object properties
    # @param contx [Hash] the properties attributes from JSON Schema
    def initialize(name, class_name, contx)
      @name = name
      @attributes = ATTRIBUTES[type]
      @type = get_objc_type(post_process_type(contx), class_name)
      @desc = contx["description"]
    end

    private

    ATTRIBUTES = {
      "array"    => "(strong, nonatomic)",
      "boolean"  => "(assign, nonatomic)",
      "integer"  => "(assign, nonatomic)",
      "unsigned" => "(assign, nonatomic)",
      "number"   => "(nonatomic)",
      "object"   => "(strong, nonatomic)",
      "string"   => "(strong, nonatomic)"
    }

    TYPES = {
      "array"    => "NSArray *",
      "boolean"  => "BOOL ",
      "integer"  => "NSInteger ",
      "unsigned" => "NSUInteger ",
      "number"   => "double ",
      "string"   => "NSString *"
    }

    def post_process_type(contx)
      case contx["type"]
      when "integer"
        return "unsigned" if contx["minimum"] && contx["minimum"] >= 0
      end
      contx["type"]
    end

    def get_objc_type(type, class_name)
      type == "object" ? "#{class_name} *" : TYPES[type]
    end
  end
end
