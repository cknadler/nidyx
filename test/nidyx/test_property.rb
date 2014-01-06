require "minitest/autorun"
require "nidyx/property"

class TestProperty < Minitest::Test
  def test_array
    obj = { "type" => "array" }
    p = Nidyx::Property.new("arr", nil, obj, false)

    assert_equal(:array, p.type)
    assert_equal(true, p.is_object?)
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
end
