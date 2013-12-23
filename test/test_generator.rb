require "minitest/autorun"
require "nidyx/generator"

class TestGenerator < Minitest::Test
  def mock_options
    {
      :json_model => false,
      :author => "Nathan Explosion",
      :company => "Dethklok"
    }
  end

  def setup
    @gen = Nidyx::Generator.new
  end
end

