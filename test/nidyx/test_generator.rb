require "minitest/autorun"
require "nidyx/generator"

class TestGenerator < Minitest::Test
  def setup
    @gen = Nidyx::Generator.new("Dethklok", {})
  end

  def test_simple_properties
    schema = {
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

    models = @gen.spawn(schema)
    assert(models != nil)
  end

  def test_nested_properties
    schema = {
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object",
      "properties" => {
        "key" => {
          "type" => "string"
        },
        "value" => {
          "type" => "object",
          "properties" => {
            "name" => {
              "type" => "string"
            },
            "count" => {
              "type" => "integer"
            }
          }
        }
      }
    }

    models = @gen.spawn(schema)
    assert(models != nil)
  end

  def test_definitions
    schema = {
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object",
      "properties" => {
        "key" => {
          "type" => "string"
        },
        "value" =>  { "$ref" => "#/definitions/obj" },
        "banner" => { "$ref" => "#/definitions/banner" }
      },
      "definitions" => {
        "obj" => {
          "type" => "object",
          "properties" => {
            "name" => {
              "type" => "string"
            },
            "count" => {
              "type" => "integer"
            }
          }
        },
        "banner" => {
          "type" => "string"
        }
      }
    }

    models = @gen.spawn(schema)
    assert(models != nil)
  end

  def test_chained_definitions
    schema = {
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object",
      "properties" => {
        "obj1" => {
          "key" => {
            "type" => "string"
          },
          "value" => { "$ref" => "#/definitions/obj2" }
        }
      },
      "definitions" => {
        "obj2" => {
          "type" => "object",
          "properties" => {
            "key" => {
              "type" => "string",
            },
            "value" => { "$ref" => "#/definitions/obj3" }
          }
        },
        "obj3" => {
          "type" => "object",
          "properties" => {
            "key" => {
              "type" => "string",
            },
            "value" => {
              "type" => "string"
            }
          }
        }
      }
    }

    models = @gen.spawn(schema)
    assert(models != nil)
  end
end

