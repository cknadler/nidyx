require "minitest/autorun"
require "nidyx/objc/model_base"

class TestModelBase < Minitest::Test

  MOCK_OPTS = {
    :author => "test_author",
    :company => "test_company",
    :project => "test_project"
  }

  def test_empty_options
    model = Nidyx::ObjCModelBase.new("ModelName", {})
    assert_equal("ModelName", model.name)
    assert_equal(nil, model.author)
    assert_equal(nil, model.owner)
    assert_equal(nil, model.project)
  end

  def test_full_options
    model = Nidyx::ObjCModelBase.new("ModelName", MOCK_OPTS)
    assert_equal("test_author", model.author)
    assert_equal("test_company", model.owner)
    assert_equal("test_project", model.project)
  end
end
