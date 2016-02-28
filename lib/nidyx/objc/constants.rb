module Nidyx
  module ObjCConstants

    PRIMITIVE_ATTRIBUTES = "assign, nonatomic".freeze
    OBJECT_ATTRIBUTES = "strong, nonatomic".freeze

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
    }.freeze

    # Objective-C types
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
    }.freeze

    # Hash and Array intentionally omitted
    ENUM_TYPES = {
      Fixnum     => :integer,
      String     => :string,
      NilClass   => :null,
      Float      => :number,
      TrueClass  => :boolean,
      FalseClass => :boolean
    }.freeze

    OBJECTS = Set.new [:array, :number_obj, :string, :object, :id].freeze

    SIMPLE_NUMBERS = Set.new [:unsigned, :integer, :number].freeze

    BOXABLE_NUMBERS = SIMPLE_NUMBERS + [:boolean].freeze

    FORBIDDEN_PROPERTY_PREFIXES = ["new", "copy"].freeze
  end
end
