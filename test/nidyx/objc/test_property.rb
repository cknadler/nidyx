require "minitest/autorun"
require "nidyx"
require "nidyx/parse_constants"
require "nidyx/property"
require "nidyx/objc/property"

include Nidyx::ParseConstants

class TestObjCProperty < Minitest::Test

  def test_is_obj
    assert_equal(true, simple_property("array").is_obj?)
    assert_equal(false, simple_property("boolean").is_obj?)
    assert_equal(false, simple_property("integer").is_obj?)
    assert_equal(false, simple_property("number").is_obj?)
    assert_equal(true, simple_property(%w(boolean null)).is_obj?)
    assert_equal(true, simple_property(%w(integer null)).is_obj?)
    assert_equal(true, simple_property(%w(number null)).is_obj?)
    assert_equal(true, simple_property("string").is_obj?)
    assert_equal(true, simple_property("object").is_obj?)
    assert_equal(true, simple_property("null").is_obj?)
  end

  def test_simple_array
    obj = { TYPE_KEY => "array" }
    p = property(obj, false)
    assert_equal(:array, p.type)
    assert_equal(nil, p.getter_override)
    assert_equal([], p.protocols)
    assert_equal(false, p.has_protocols?)

    # optional array
    p = property(obj, true)
    assert_equal(:array, p.type)
    assert_equal(["Optional"], p.protocols)
    assert_equal(true, p.has_protocols?)
  end

  def test_typed_optional_array
    obj = { TYPE_KEY => ["array", "null"] }
    p = property(obj, false)
    assert_equal(:array, p.type)
    assert_equal(["Optional"], p.protocols)
  end

  def test_typed_array_with_protocls
    obj = { TYPE_KEY => ["array" ], COLLECTION_TYPES_KEY => ["aClass", "string"]  }
    p = property(obj, false)
    assert_equal(:array, p.type)
    assert_equal(["aClass"], p.protocols)
  end

  def test_boolean
    obj = { TYPE_KEY => "boolean" }
    p = property(obj, false)
    assert_equal(:boolean, p.type)

    # optional boolean
    p = property(obj, true)
    assert_equal(:number_obj, p.type)
  end

  def test_typed_optional_boolean
    obj = { TYPE_KEY => ["boolean", "null"] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
  end

  def test_integer
    obj = { TYPE_KEY => "integer" }
    p = property(obj, false)
    assert_equal(:integer, p.type)

    p = property(obj, true)
    assert_equal(:number_obj, p.type)
    assert_equal(["Optional"], p.protocols)
  end

  def test_unsigned_integer
    obj = { TYPE_KEY => "integer", "minimum" => 0 }
    p = property(obj, false)
    assert_equal(:unsigned, p.type)
  end

  def test_typed_optional_integer
    obj = { TYPE_KEY => ["integer", "null"] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
    assert_equal(["Optional"], p.protocols)
  end

  def test_number
    obj = { TYPE_KEY => "number" }
    p = property(obj, false)
    assert_equal(:number, p.type)

    p = property(obj, true)
    assert_equal(:number_obj, p.type)
  end

  def test_typed_optional_number
    obj = { TYPE_KEY => ["number", "null"] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
  end

  def test_string
    obj = { TYPE_KEY => "string" }
    p = property(obj, false)
    assert_equal(:string, p.type)

    p = property(obj, true)
    assert_equal(:string, p.type)
  end

  def test_typed_optional_string
    obj = { TYPE_KEY => ["string", "null"] }
    p = property(obj, false)
    assert_equal(:string, p.type)
  end

  def test_object
    obj = {
      TYPE_KEY => "object",
      PROPERTIES_KEY => {}
    }

    p = property(obj, false)
    assert_equal(:object, p.type)
  end

  def test_multiple_numeric_types
    obj = { TYPE_KEY => ["number", "integer", "boolean"] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
  end

  def test_typed_optional_multiple_numeric_types
    obj = { TYPE_KEY => ["number", "integer", "boolean", "null"] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
    assert_equal(["Optional"], p.protocols)
  end

  def test_multiple_disparate_types
    obj = { TYPE_KEY => ["object", "number"] }
    p = property(obj, false)
    assert_equal(:id, p.type)
  end

  def test_typed_optional_multiple_disparate_types
    obj = { TYPE_KEY => ["object", "number", "null"] }
    p = property(obj, false)
    assert_equal(:id, p.type)
  end

  def test_simple_numbers
    obj = { TYPE_KEY => [ "integer", "number" ] }
    p = property(obj, false)
    assert_equal(:number, p.type)

    p = property(obj, true)
    assert_equal(:number_obj, p.type)
  end

  def test_typed_optional_simple_numbers
    obj = { TYPE_KEY => [ "integer", "number", "null" ] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
  end

  def test_integer_enum
    obj = { ENUM_KEY => [1, 2] }
    p = property(obj, false)
    assert_equal(:integer, p.type)

    p = property(obj, true)
    assert_equal(:number_obj, p.type)
    assert_equal(["Optional"], p.protocols)
  end

  def test_string_enum
    obj = { ENUM_KEY => ["a", "b"] }
    p = property(obj, false)
    assert_equal(:string, p.type)
  end

  def test_typed_optional_enum
    obj = { ENUM_KEY => [1, 2, nil] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
    assert_equal(["Optional"], p.protocols)
  end

  def test_single_element_array_type
    obj = { TYPE_KEY => ["integer"] }
    p = property(obj, false)
    assert_equal(:integer, p.type)
  end

  def test_anonymous_object
    obj = { TYPE_KEY => "object" }
    p = property(obj, false)
    assert_equal(:id, p.type)
  end

  def test_unsafe_getter
    obj = { TYPE_KEY => "integer" }
    p = Nidyx::ObjCProperty.new(Nidyx::Property.new("newInt", nil, false, obj))
    assert_equal(", getter=getNewInt", p.getter_override)
  end

  def test_protocols
    obj = {
      TYPE_KEY => "array",
      COLLECTION_TYPES_KEY => ["SomeModel", "OtherModel"]
    }

    p = property(obj, false)
    assert_equal(true, p.has_protocols?)
    assert_equal("SomeModel, OtherModel", p.protocols_string)
    assert_equal(%w(SomeModel OtherModel), p.protocols)

    p = property(obj, true)
    assert_equal(true, p.has_protocols?)
    assert_equal("SomeModel, OtherModel, Optional", p.protocols_string)
    assert_equal(%w(SomeModel OtherModel Optional), p.protocols)
  end

  def test_unsupported_types_enum
    assert_raises(Nidyx::ObjCUtils::UnsupportedEnumTypeError) do
      obj = { ENUM_KEY => ["a", {}] }
      Nidyx::ObjCProperty.new(Nidyx::Property.new("i", nil, false, obj))
    end
  end

  private

  def simple_property(type)
    obj = { TYPE_KEY => type }
    Nidyx::ObjCProperty.new(Nidyx::Property.new("p", nil, false, obj))
  end

  def property(obj, optional, class_name = nil)
    Nidyx::ObjCProperty.new(Nidyx::Property.new("name", class_name, optional, obj))
  end
end
