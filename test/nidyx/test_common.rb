require "minitest/autorun"
require "nidyx"
require "nidyx/common"

include Nidyx::Common

class TestCommon < Minitest::Test
  def test_class_name
    assert_equal("DKResponseModel", class_name("DK", "response"))
    assert_equal("DKModel", class_name("DK", nil))
    assert_equal("DKLargeButtonModel", class_name("DK", "large_button"))
  end

  def test_class_name_from_path
    path = ["properties", "obj", "properties", "value"]
    assert_equal("DKObjValueModel", class_name_from_path("DK", path))

    path = ["definitions", "obj", "properties", "value"]
    assert_equal("DKObjValueModel", class_name_from_path("DK", path))

    assert_equal("DKModel", class_name_from_path("DK", []))
  end

  def test_header_path
    name = "DKModel"
    assert_equal(name + ".h", header_path(name))
  end

  def test_implementation_path
    name = "DKModel"
    assert_equal(name + ".m", implementation_path(name))
  end
end
