require "minitest/autorun"
require "nidyx"
require "nidyx/common"

include Nidyx::Common

class TestCommon < Minitest::Test
  def test_class_name
    assert("DKResponseModel" == class_name("DK", "response"))
    assert("DKModel" == class_name("DK", nil))
    assert("DKLargeButtonModel" == class_name("DK", "large_button"))
  end

  def test_header_path
    name = "DKModel"
    assert(name + ".h" == header_path(name))
  end

  def test_implementation_path
    name = "DKModel"
    assert(name + ".m" == implementation_path(name))
  end
end
