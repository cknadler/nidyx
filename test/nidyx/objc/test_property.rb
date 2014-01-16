require "minitest/autorun"
require "nidyx"
require "nidyx/property"
require "nidyx/objc/property"

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
    obj = { "type" => "array" }
    p = property(obj, false)
    assert_equal(:array, p.type)
    assert_equal(nil, p.getter_override)

    # optional array
    p = property(obj, true)
    assert_equal(:array, p.type)
    assert_equal(true, p.optional)
  end

  def test_typed_optional_array
    obj = { "type" => ["array", "null"] }
    p = property(obj, false)
    assert_equal(:array, p.type)
    assert_equal(true, p.optional)
  end

  def test_boolean
    obj = { "type" => "boolean" }
    p = property(obj, false)
    assert_equal(:boolean, p.type)

    # optional boolean
    p = property(obj, true)
    assert_equal(:number_obj, p.type)
  end

  def test_typed_optional_boolean
    obj = { "type" => ["boolean", "null"] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
  end

  def test_integer
    obj = { "type" => "integer" }
    p = property(obj, false)
    assert_equal(:integer, p.type)

    p = property(obj, true)
    assert_equal(:number_obj, p.type)
    assert_equal(true, p.optional)
  end

  def test_typed_optional_integer
    obj = { "type" => ["integer", "null"] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
    assert_equal(true, p.optional)
  end

  def test_unsigned
    obj = { "type" => "integer", "minimum" => 0 }
    p = property(obj, false)
    assert_equal(:unsigned, p.type)
  end

  def test_number
    obj = { "type" => "number" }
    p = property(obj, false)
    assert_equal(:number, p.type)

    p = property(obj, true)
    assert_equal(:number_obj, p.type)
  end

  def test_typed_optional_number
    obj = { "type" => ["number", "null"] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
  end

  def test_string
    obj = { "type" => "string" }
    p = property(obj, false)
    assert_equal(:string, p.type)

    p = property(obj, true)
    assert_equal(:string, p.type)
  end

  def test_typed_optional_string
    obj = { "type" => ["string", "null"] }
    p = property(obj, false)
    assert_equal(:string, p.type)
  end

  def test_object
    obj = {
      "type" => "object",
      "properties" => {}
    }

    p = property(obj, false)
    assert_equal(:object, p.type)
  end

  def test_multiple_numeric_types
    obj = { "type" => ["number", "integer", "boolean"] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
  end

  def test_typed_optional_multiple_numeric_types
    obj = { "type" => ["number", "integer", "boolean", "null"] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
    assert_equal(true, p.optional)
  end

  def test_multiple_disparate_types
    obj = { "type" => ["object", "number"] }
    p = property(obj, false)
    assert_equal(:id, p.type)
  end

  def test_typed_optional_multiple_disparate_types
    obj = { "type" => ["object", "number", "null"] }
    p = property(obj, false)
    assert_equal(:id, p.type)
  end

  def test_simple_numbers
    obj = { "type" => [ "integer", "number" ] }
    p = property(obj, false)
    assert_equal(:number, p.type)

    p = property(obj, true)
    assert_equal(:number_obj, p.type)
  end

  def test_typed_optional_simple_numbers
    obj = { "type" => [ "integer", "number", "null" ] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
  end

  def test_integer_enum
    obj = { "enum" => [1, 2] }
    p = property(obj, false)
    assert_equal(:integer, p.type)

    p = property(obj, true)
    assert_equal(:number_obj, p.type)
    assert_equal(true, p.optional)
  end

  def test_string_enum
    obj = { "enum" => ["a", "b"] }
    p = property(obj, false)
    assert_equal(:string, p.type)
  end

  def test_typed_optional_enum
    obj = { "enum" => [1, 2, nil] }
    p = property(obj, false)
    assert_equal(:number_obj, p.type)
    assert_equal(true, p.optional)
  end

  def test_single_element_array_type
    obj = { "type" => ["integer"] }
    p = property(obj, false)
    assert_equal(:integer, p.type)
  end

  def test_anonymous_object
    obj = { "type" => "object" }
    p = property(obj, false)
    assert_equal(:id, p.type)
  end

  def test_unsafe_getter
    obj = { "type" => "integer" }
    p = Nidyx::ObjCProperty.new(Nidyx::Property.new("newInt", nil, false, obj))
    assert_equal(", getter=getNewInt", p.getter_override)
  end

  def test_unsupported_types_enum
    assert_raises(Nidyx::ObjCProperty::UnsupportedEnumTypeError) do
      obj = { "enum" => ["a", {}] }
      Nidyx::ObjCProperty.new(Nidyx::Property.new("i", nil, false, obj))
    end
  end

  private

  def simple_property(type)
    obj = { "type" => type }
    Nidyx::ObjCProperty.new(Nidyx::Property.new("p", nil, false, obj))
  end

  def property(obj, optional, class_name = nil)
    Nidyx::ObjCProperty.new(Nidyx::Property.new("name", class_name, optional, obj))
  end
end
