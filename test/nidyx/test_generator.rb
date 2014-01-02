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
   assert_equal("TSTModel", model[:h].name)
   assert_equal("TSTModel.h", model[:h].file_name)
   assert_equal(nil, model[:h].author)
   assert_equal(nil, model[:h].company)
   assert_equal(nil, model[:h].project)
   assert_equal(nil, model[:h].imports)

    # properties
    props = model[:h].properties

    key = props["key"]
   assert_equal("key", key.name)
   assert_equal("string", key.type)
   assert_equal(nil, key.class_name)
   assert_equal(nil, key.desc)

    value = props["value"]
   assert_equal("value", value.name)
   assert_equal("string", value.type)
   assert_equal(nil, value.class_name)
   assert_equal(nil, value.desc)

    # implementation
   assert_equal("TSTModel", model[:m].name)
   assert_equal("TSTModel.m", model[:m].file_name)
   assert_equal(nil, model[:m].author)
   assert_equal(nil, model[:m].company)
   assert_equal(nil, model[:m].project)
   assert_equal(["TSTModel.h"], model[:m].imports)
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
   assert_equal("TSTModel", model[:h].name)
   assert_equal("TSTModel.h", model[:h].file_name)

    # properties
    props = model[:h].properties

    key = props["key"]
   assert_equal("key", key.name)
   assert_equal("string", key.type)

    value = props["value"]
   assert_equal("value", value.name)
   assert_equal("object", value.type)
   assert_equal("TSTValueModel", value.class_name)

    # implementation
   assert_equal("TSTModel", model[:m].name)
   assert_equal("TSTModel.m", model[:m].file_name)
   assert_equal(["TSTModel.h", "TSTValueModel.h"], model[:m].imports)

    ###
    # first nested model
    ###
    model = models["TSTValueModel"]

    # header
   assert_equal("TSTValueModel", model[:h].name)
   assert_equal("TSTValueModel.h", model[:h].file_name)

    # properties
    props = model[:h].properties

    name = props["name"]
   assert_equal("name", name.name)
   assert_equal("string", name.type)

    obj = props["obj"]
   assert_equal("obj", obj.name)
   assert_equal("object", obj.type)
   assert_equal("TSTValueObjModel", obj.class_name)

    # implementation
   assert_equal("TSTValueModel", model[:m].name)
   assert_equal("TSTValueModel.m", model[:m].file_name)
   assert_equal(["TSTValueModel.h", "TSTValueObjModel.h"], model[:m].imports)

    ###
    # second nested model
    ###
    model = models["TSTValueObjModel"]

    # header
   assert_equal("TSTValueObjModel", model[:h].name)
   assert_equal("TSTValueObjModel.h", model[:h].file_name)

    # properties
    props = model[:h].properties

    id = props["id"]
   assert_equal("id", id.name)
   assert_equal("string", id.type)

    data = props["data"]
   assert_equal("data", data.name)
   assert_equal("string", data.type)

    # implementation
   assert_equal("TSTValueObjModel", model[:m].name)
   assert_equal("TSTValueObjModel.m", model[:m].file_name)
   assert_equal(["TSTValueObjModel.h"], model[:m].imports)
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

