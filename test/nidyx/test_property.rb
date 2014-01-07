require "minitest/autorun"
require "nidyx/property"

class TestProperty < Minitest::Test
  def test_is_obj
    assert_equal(true, make_simple_property("array").is_obj?)
    assert_equal(false, make_simple_property("boolean").is_obj?)
    assert_equal(false, make_simple_property("integer").is_obj?)
    assert_equal(false, make_simple_property("unsigned").is_obj?)
    assert_equal(false, make_simple_property("number").is_obj?)
    assert_equal(true, make_simple_property(["number", "null"]).is_obj?)
    assert_equal(true, make_simple_property("string").is_obj?)
    assert_equal(true, make_simple_property("object").is_obj?)
    assert_equal(true, make_simple_property("null").is_obj?)
  end

  def test_simple_array
    obj = { "type" => "array" }
    p = Nidyx::Property.new("arr", nil, obj, false)
    assert_equal(:array, p.type)
  end

  def test_explicit_optional_array
    obj = { "type" => "array" }
    p = Nidyx::Property.new("arr", nil, obj, true)
    assert_equal(:array, p.type)
  end

  def test_typed_optional_array
    obj = { "type" => ["array", "null"] }
    p = Nidyx::Property.new("arr", nil, obj, false)
    assert_equal(:array, p.type)
    assert_equal(true, p.optional)
  end

  def test_simple_boolean
    obj = { "type" => "boolean" }
    p = Nidyx::Property.new("b", nil, obj, false)
    assert_equal(:boolean, p.type)
  end

  def test_explicit_optional_boolean
    obj = { "type" => "boolean" }
    p = Nidyx::Property.new("b", nil, obj, true)
    assert_equal(:number_obj, p.type)
  end

  def test_typed_optional_boolean
    obj = { "type" => ["boolean", "null"] }
    p = Nidyx::Property.new("b", nil, obj, false)
    assert_equal(:number_obj, p.type)
  end

  def test_simple_integer
    obj = { "type" => "integer" }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:integer, p.type)
  end

  def test_explicit_optional_integer
    obj = { "type" => "integer" }
    p = Nidyx::Property.new("i", nil, obj, true)
    assert_equal(:number_obj, p.type)
    assert_equal(true, p.optional)
  end

  def test_typed_optional_integer
    obj = { "type" => ["integer", "null"] }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:number_obj, p.type)
    assert_equal(true, p.optional)
  end

  def test_simple_unsigned
    obj = { "type" => "integer", "minimum" => 0 }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:unsigned, p.type)
  end

  def test_simple_number
    obj = { "type" => "number" }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:number, p.type)
  end

  def test_explicit_optional_number
    obj = { "type" => "number" }
    p = Nidyx::Property.new("i", nil, obj, true)
    assert_equal(:number_obj, p.type)
    assert_equal(true, p.optional)
  end

  def test_typed_optional_number
    obj = { "type" => ["number", "null"] }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:number_obj, p.type)
    assert_equal(true, p.optional)
  end

  def test_simple_string
    obj = { "type" => "string" }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:string, p.type)
    assert_equal(false, p.optional)
  end

  def test_explicit_optional_string
    obj = { "type" => "string", }
    p = Nidyx::Property.new("i", nil, obj, true)
    assert_equal(:string, p.type)
    assert_equal(true, p.optional)
  end

  def test_typed_optional_string
    obj = { "type" => ["string", "null"] }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:string, p.type)
    assert_equal(true, p.optional)
  end

  def test_simple_object
    obj = { "type" => "object" }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:object, p.type)
    assert_equal(false, p.optional)
  end

  def test_multiple_numeric_types
    obj = { "type" => ["number", "integer", "boolean"] }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:number_obj, p.type)
  end

  def test_explicit_optional_multiple_numeric_types
    obj = { "type" => ["number", "integer", "boolean"] }
    p = Nidyx::Property.new("i", nil, obj, true)
    assert_equal(:number_obj, p.type)
    assert_equal(true, p.optional)
  end

  def test_typed_optional_multiple_numeric_types
    obj = { "type" => ["number", "integer", "boolean", "null"] }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:number_obj, p.type)
    assert_equal(true, p.optional)
  end

  def test_multiple_disparate_types
    obj = { "type" => ["object", "number"] }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:id, p.type)
  end

  def test_multiple_disparate_types
    obj = { "type" => ["object", "number", "null"] }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:id, p.type)
  end

  def test_untyped
    obj = { "enum" => ["a", "b"] }
    p = Nidyx::Property.new("i", nil, obj, false)
    assert_equal(:string, p.type)
  end

  def test_explicit_optional_untyped
    obj = { "enum" => ["a", "b"] }
    p = Nidyx::Property.new("i", nil, obj, true)
    assert_equal(:string, p.type)
    assert_equal(true, p.optional)
  end

  private

  def make_simple_property(type)
    obj = { "type" => type }
    Nidyx::Property.new("p", nil, obj, false)
  end
end
