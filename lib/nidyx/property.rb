module Nidyx
  class Property
    attr_reader :type, :name, :class_name, :desc

    DEFINITIONS =
      {
        "array" => "(strong, nonatomic) NSArray* ",
        "boolean" => "(nonatomic, assign) BOOL ",
        "integer" => "(nonatomic, assign) NSInteger ",
        "number" => "(nonatomic) double ",
        "object" => "(strong, nonatomic) ",
        "string" => "(strong, nonatomic) NSString* "
      }

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
