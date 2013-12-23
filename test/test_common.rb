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
end
