require "minitest/autorun"
require "nidyx/property"

class TestProperty < Minitest::Test
  def test_array_property
    prop = Nidyx::Property.new("bList", "array", nil, nil)
    assert_equal(prop.to_s, "@property (strong, nonatomic) NSArray* bList")
  end

  def test_obj_property
    prop = Nidyx::Property.new("bObj", "object", "DKSomeClass", nil)
    assert_equal(prop.to_s, "@property (strong, nonatomic) DKSomeClass* bObj")
  end

  def test_property_description
    prop = Nidyx::Property.new("bInt", "integer", nil, "description")
    assert_equal(prop.to_s, "// description\n" +
      "@property (assign, nonatomic) NSInteger bInt")
  end
end
