require "minitest/autorun"
require "nidyx"
require "nidyx/property"

class TestProperty < Minitest::Test
  def test_name_camelized
    obj = { "type" => "string" }
    p = Nidyx::Property.new("underscore_string", nil, false, obj)
    assert_equal("underscoreString", p.name)
  end

  def test_typeless
    assert_raises(Nidyx::Property::UndefinedTypeError) do
      Nidyx::Property.new("i", nil, false, {})
    end
  end

  def test_empty_type_array
    assert_raises(Nidyx::Property::UndefinedTypeError) do
      obj = { "type" => [] }
      Nidyx::Property.new("i", nil, false, obj)
    end
  end

  def test_non_array_enum
    assert_raises(Nidyx::Property::NonArrayEnumError) do
      obj = { "enum" => {} }
      Nidyx::Property.new("i", nil, false, obj)
    end
  end

  def test_empty_enum_array
    assert_raises(Nidyx::Property::EmptyEnumError) do
      obj = { "enum" => [] }
      Nidyx::Property.new("i", nil, false, obj)
    end
  end
end
