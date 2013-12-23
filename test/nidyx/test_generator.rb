require "minitest/autorun"
require "nidyx/generator"

class TestGenerator < Minitest::Test
  def setup
    @gen = Nidyx::Generator.new("Dethklok", nil, {})
  end

  def test_generator
    skip
  end
end

