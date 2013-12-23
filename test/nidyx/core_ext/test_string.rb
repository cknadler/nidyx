require "minitest/autorun"
require "nidyx"

class TestCoreExt < Minitest::Test
  def test_camelize
    assert_equal("CamelCaseString", "camelCaseString".camelize)
    assert_equal("CamelCaseString", "camel_case_string".camelize)
    assert_equal("CamelCaseString", "Camel_Case_String".camelize)
    assert_equal("CamelCaseString", "camel_Case_STRING".camelize)
    assert_equal("CamelCaseString", "CamelCaseString".camelize)
    assert_equal("1IsTheLonliestNumber", "1_is_the_lonliest_number".camelize)
  end
end
