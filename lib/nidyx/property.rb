module Nidyx
  class Property
    attr_reader :name, :attributes, :type, :class_name, :desc

    TYPES = {

    }

    DEFINITIONS = {
      "array" => "(strong, nonatomic) NSArray *",
      "boolean" => "(assign, nonatomic) BOOL ",
      "integer" => "(assign, nonatomic) NSInteger ",
      "number" => "(nonatomic) double ",
      "object" => "(strong, nonatomic) ",
      "string" => "(strong, nonatomic) NSString *"
    }

    # @param name [String] property name
    # @param type [String] the property's type
    # @param class_name [String] class name, only for object properties
    # @param desc [String] optional description
    def initialize(name, type, class_name, desc)
      @name = name
      @type = type
      @class_name = class_name
      @desc = desc
    end
  end
end
