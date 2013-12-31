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

    ###
    # root model tests
    ###
    model = models["DethklokModel"]

    # header
    assert(model[:h].name == "DethklokModel")
    assert(model[:h].file_name == "DethklokModel.h")
    assert(model[:h].author == nil)
    assert(model[:h].company == nil)
    assert(model[:h].project == nil)
    assert(model[:h].imports == nil)

    # properties
    props = model[:h].properties

    key = props["key"]
    assert(key.type == "string")
    assert(key.name == "key")
    assert(key.class_name == nil)
    assert(key.desc == nil)

    value = props["value"]
    assert(value.type == "string")
    assert(value.name == "value")
    assert(value.class_name == nil)
    assert(value.desc == nil)

    # implementation
    assert(model[:m].name == "DethklokModel")
    assert(model[:m].file_name == "DethklokModel.m")
    assert(model[:m].author == nil)
    assert(model[:m].company == nil)
    assert(model[:m].project == nil)
    assert(model[:m].imports == ["DethklokModel.h"])
  end

  def test_deeply_nested_properties
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
            "obj" => {
              "type" => "object",
              "properties" => {
                "id" => {
                  "type" => "string"
                },
                "data" => {
                  "type" => "string"
                }
              }
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

