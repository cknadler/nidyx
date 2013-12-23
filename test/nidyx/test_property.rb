require "minitest/autorun"
require "nidyx/property"

class TestProperty < Minitest::Test
  def test_array_property
    prop = Nidyx::Property.new("array", "bList", nil, nil)
    assert_equal(prop.to_s, "@property (strong, nonatomic) NSArray* bList")
  end

  def test_obj_property
    prop = Nidyx::Property.new("object", "bObj", "DKSomeClass", nil)
    assert_equal(prop.to_s, "@property (strong, nonatomic) DKSomeClass* bObj")
  end

  def test_property_description
    prop = Nidyx::Property.new("integer", "bInt", nil, "description")
    assert_equal(prop.to_s, "// description\n" +
      "@property (nonatomic, assign) NSInteger bInt")
  end
end
