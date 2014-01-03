require "minitest/autorun"
require "nidyx/model_base"

class TestModelBase < Minitest::Test

  MOCK_OPTS = {
    :author => "test_author",
    :company => "test_company",
    :project => "test_project"
  }

  def test_empty_options
    model = Nidyx::ModelBase.new("ModelName", {})
    assert_equal("ModelName", model.name)
    assert_equal(ENV['USER'], model.author)
    assert_equal(ENV['USER'], model.owner)
    assert_equal(nil, model.project)
  end

  def test_full_options
    model = Nidyx::ModelBase.new("ModelName", MOCK_OPTS)
    assert_equal("test_author", model.author)
    assert_equal("test_company", model.owner)
    assert_equal("test_project", model.project)
  end
end
