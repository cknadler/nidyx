module Nidyx
  class Property
    attr_reader :type, :name, :class_name, :desc

    # @param type [String] the property's type
    # @param name [String] property name
    # @param class_name [String] class name, only for object properties
    # @param desc [String] optional description
    def initialize(type, name, class_name, desc)
      @type = type
      @name = name
      @class_name = class_name
      @desc = desc
    end

    def to_s
      if self.desc
        "// " + self.desc + "\n" + property
      else
        property
      end
    end

    private

    DEFINITIONS =
      {
        "array" => "(strong, nonatomic) NSArray* ",
        "boolean" => "(assign, nonatomic) BOOL ",
        "integer" => "(assign, nonatomic) NSInteger ",
        "number" => "(nonatomic) double ",
        "object" => "(strong, nonatomic) ",
        "string" => "(strong, nonatomic) NSString* "
      }

    def property
      base = "@property " + DEFINITIONS[self.type]
      if self.type == "object"
        base + self.class_name + "* " + self.name
      else
        base + self.name
      end
    end
  end
end
