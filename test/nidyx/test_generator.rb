require "nidyx"
require "minitest/autorun"
require "nidyx/generator"

class TestGenerator < Minitest::Test
  def setup
    @gen = Nidyx::Generator.new("TST", {})
  end

  def test_empty_schema
    schema = { "type" => "object" }

    begin
      @gen.spawn(schema)
      assert(false)
    rescue EmptySchemaError
      assert(true)
    end
  end

  def test_simple_properties
    schema = {
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object",
      "properties" => {
        "key" => { "type" => "string" },
        "value" => { "type" => "string" }
      }
    }

    models = @gen.spawn(schema)

    ###
    # root model tests
    ###
    model = models["TSTModel"]

    # header
    assert(model[:h].name == "TSTModel")
    assert(model[:h].file_name == "TSTModel.h")
    assert(model[:h].author == nil)
    assert(model[:h].company == nil)
    assert(model[:h].project == nil)
    assert(model[:h].imports == nil)

    # properties
    props = model[:h].properties

    key = props["key"]
    assert(key.name == "key")
    assert(key.type == "string")
    assert(key.class_name == nil)
    assert(key.desc == nil)

    value = props["value"]
    assert(value.name == "value")
    assert(value.type == "string")
    assert(value.class_name == nil)
    assert(value.desc == nil)

    # implementation
    assert(model[:m].name == "TSTModel")
    assert(model[:m].file_name == "TSTModel.m")
    assert(model[:m].author == nil)
    assert(model[:m].company == nil)
    assert(model[:m].project == nil)
    assert(model[:m].imports == ["TSTModel.h"])
  end

  def test_deeply_nested_properties
    schema = {
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object",
      "properties" => {
        "key" => { "type" => "string" },
        "value" => {
          "type" => "object",
          "properties" => {
            "name" => { "type" => "string" },
            "obj" => {
              "type" => "object",
              "properties" => {
                "id" => { "type" => "string" },
                "data" => { "type" => "string" }
              }
            }
          }
        }
      }
    }

    models = @gen.spawn(schema)

    ###
    # root model tests
    ###
    model = models["TSTModel"]

    # header
    assert(model[:h].name == "TSTModel")
    assert(model[:h].file_name == "TSTModel.h")

    # properties
    props = model[:h].properties

    key = props["key"]
    assert(key.name == "key")
    assert(key.type == "string")

    value = props["value"]
    assert(value.name == "value")
    assert(value.type == "object")
    assert_equal("TSTValueModel", value.class_name)

    # implementation
    assert(model[:m].name == "TSTModel")
    assert(model[:m].file_name == "TSTModel.m")
    assert(model[:m].imports == ["TSTModel.h", "TSTValueModel.h"])

    ###
    # first nested model
    ###
    model = models["TSTValueModel"]

    # header
    assert(model[:h].name == "TSTValueModel")
    assert(model[:h].file_name == "TSTValueModel.h")

    # properties
    props = model[:h].properties

    name = props["name"]
    assert(name.name == "name")
    assert(name.type == "string")

    obj = props["obj"]
    assert(obj.name == "obj")
    assert(obj.type == "object")
    assert(obj.class_name == "TSTValueObjModel")

    # implementation
    assert(model[:m].name == "TSTValueModel")
    assert(model[:m].file_name == "TSTValueModel.m")
    assert(model[:m].imports == ["TSTValueModel.h", "TSTValueObjModel.h"])

    ###
    # second nested model
    ###
    model = models["TSTValueObjModel"]

    # header
    assert(model[:h].name == "TSTValueObjModel")
    assert(model[:h].file_name == "TSTValueObjModel.h")

    # properties
    props = model[:h].properties

    id = props["id"]
    assert(id.name == "id")
    assert(id.type == "string")

    data = props["data"]
    assert(data.name == "data")
    assert(data.type == "string")

    # implementation
    assert(model[:m].name == "TSTValueObjModel")
    assert(model[:m].file_name == "TSTValueObjModel.m")
    assert(model[:m].imports == ["TSTValueObjModel.h"])
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

