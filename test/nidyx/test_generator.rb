require "minitest/autorun"
require "nidyx/generator"

class TestGenerator < Minitest::Test
  def setup
    @gen = Nidyx::Generator.new("Dethklok", nil, {})
  end

  def test_simple_properties
    schema =
      {
        "$schema" => "http://json-schema.org/draft-04/schema#",
        "type" => "object",
        "properties" => {
          "key" => {
            "type" => "string"
          },
          "value" => {
            "type" => "string"
          }
        }
      }

    @gen.spawn(schema)
  end
end

