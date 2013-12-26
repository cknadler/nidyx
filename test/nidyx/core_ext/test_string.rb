require "minitest/autorun"
require "nidyx"

class TestCoreExt < Minitest::Test
  def test_camelize
    assert_equal("CamelCaseString", "camelCaseString".camelize)
    assert_equal("CamelCaseString", "camel_case_string".camelize)
    assert_equal("CamelCaseString", "Camel_Case_String".camelize)
    assert_equal("CamelCaseString", "camel_Case_STRING".camelize)
    assert_equal("1IsTheLoneliestNumber", "1_is_the_loneliest_number".camelize)
    assert_equal("CCString", "CCString".camelize)
  end

  def test_camelize_with_optional_param
    assert_equal("CamelCaseString", "camelCaseString".camelize(true))
    assert_equal("camelCaseString", "CamelCaseString".camelize(false))
    assert_equal("camelCaseString", "camel_case_string".camelize(false))
    assert_equal("camelCaseString", "camel_case_string".camelize(false))
    assert_equal("camelCaseString", "Camel_Case_String".camelize(false))
    assert_equal("camelCaseString", "camel_Case_STRING".camelize(false))
    assert_equal("1IsTheLoneliestNumber", "1_is_the_loneliest_number".camelize(false))
  end

  def test_camelize_unchanged
    assert_equal("CamelCaseString", "CamelCaseString".camelize)
    assert_equal("CamelCaseString", "CamelCaseString".camelize(true))
    assert_equal("camelCaseString", "camelCaseString".camelize(false))
  end

  def test_camelize_with_plain_numbers
    assert_equal("123121151", "123121151".camelize)
    assert_equal("123121151", "123121151".camelize(false))
  end

  def test_camelize_leaves_original_in_tact
    string = "camel_case_string"
    assert_equal("CamelCaseString", string.camelize)
    assert_equal("camel_case_string", string)
  end
end
