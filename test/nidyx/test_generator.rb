require "minitest/autorun"
require "nidyx" # we use some core_ext stuff that requires this
require "nidyx/generator"

class TestGenerator < Minitest::Test
  def setup
    @gen = Nidyx::Generator.new("TST", {})
  end

  # Do basic validation of a class's `.h` and `.m` file
  # Return the model for further validation once this is complete
  def validate_model_files(models, name, header_imports)
    model = models[name]

    # header
    assert_equal(name, model[:h].name)
    assert_equal(name + ".h", model[:h].file_name)
    assert_equal(header_imports, model[:h].imports)

    # implementation
    assert_equal(name, model[:m].name)
    assert_equal(name + ".m", model[:m].file_name)
    assert_equal([name], model[:m].imports)

    model
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

  def test_description
    schema = {
      "type" => "object",
      "properties" => {
        "key" => {
          "description" => "a description",
          "type" => "string"
        }
      }
    }

    models = @gen.spawn(schema)
    model = models["TSTModel"]
    props = model[:h].properties

    assert_equal("a description", props.shift.desc)
  end

  def test_simple_properties
    schema = {
      "type" => "object",
      "properties" => {
        "key" => { "type" => "string" },
        "value" => { "type" => "string" }
      }
    }

    models = @gen.spawn(schema)
    model = validate_model_files(models, "TSTModel", [])

    # properties
    props = model[:h].properties

    key = props.shift
    assert_equal("key", key.name)
    assert_equal("NSString *", key.type)
    assert_equal(nil, key.desc)

    value = props.shift
    assert_equal("value", value.name)
    assert_equal("NSString *", value.type)
    assert_equal(nil, value.desc)
  end

  def test_deeply_nested_properties
    schema = {
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
    # root model
    ###
    model = validate_model_files(models, "TSTModel", ["TSTValueModel"])

    # properties
    props = model[:h].properties

    key = props.shift
    assert_equal("key", key.name)
    assert_equal("NSString *", key.type)

    value = props.shift
    assert_equal("value", value.name)
    assert_equal("TSTValueModel *", value.type)

    ###
    # value model
    ###
    model = validate_model_files(models, "TSTValueModel", ["TSTValueObjModel"])

    # properties
    props = model[:h].properties

    name = props.shift
    assert_equal("name", name.name)
    assert_equal("NSString *", name.type)

    obj = props.shift
    assert_equal("obj", obj.name)
    assert_equal("TSTValueObjModel *", obj.type)

    ###
    # value obj model
    ###
    model = validate_model_files(models, "TSTValueObjModel", [])

    # properties
    props = model[:h].properties

    id = props.shift
    assert_equal("id", id.name)
    assert_equal("NSString *", id.type)

    data = props.shift
    assert_equal("data", data.name)
    assert_equal("NSString *", data.type)
  end

  def test_definitions
    schema = {
      "type" => "object",
      "properties" => {
        "key" => { "type" => "string" },
        "value" =>  { "$ref" => "#/definitions/obj" },
        "banner" => { "$ref" => "#/definitions/banner" }
      },
      "definitions" => {
        "obj" => {
          "type" => "object",
          "properties" => {
            "name" => { "type" => "string" },
            "count" => { "type" => "integer" }
          }
        },
        "banner" => { "type" => "string" }
      }
    }

    models = @gen.spawn(schema)

    ###
    # root model
    ###
    model = validate_model_files(models, "TSTModel", ["TSTObjModel"])

    # properties
    props = model[:h].properties

    key = props.shift
    assert_equal("key", key.name)
    assert_equal("NSString *", key.type)

    value = props.shift
    assert_equal("value", value.name)
    assert_equal("TSTObjModel *", value.type)

    banner = props.shift
    assert_equal("banner", banner.name)
    assert_equal("NSString *", banner.type)

    ###
    # obj model
    ###
    model = validate_model_files(models, "TSTObjModel", [])

    # properties
    props = model[:h].properties

    name = props.shift
    assert_equal("name", name.name)
    assert_equal("NSString *", name.type)

    count = props.shift
    assert_equal("count", count.name)
    assert_equal("NSInteger ", count.type)
  end

  def test_chained_definitions
    schema = {
      "type" => "object",
      "properties" => {
        "key" => { "type" => "string" },
        "value" => { "$ref" => "#/definitions/obj2" }
      },
      "definitions" => {
        "obj2" => {
          "type" => "object",
          "properties" => {
            "key" => { "type" => "string" },
            "value" => { "$ref" => "#/definitions/obj3" }
          }
        },
        "obj3" => {
          "type" => "object",
          "properties" => {
            "key" => { "type" => "string" },
            "value" => { "type" => "string" }
          }
        }
      }
    }

    models = @gen.spawn(schema)

    ###
    # root model
    ###
    model = validate_model_files(models, "TSTModel", ["TSTObj2Model"])

    # properties
    props = model[:h].properties

    key = props.shift
    assert_equal("key", key.name)
    assert_equal("NSString *", key.type)

    value = props.shift
    assert_equal("value", value.name)
    assert_equal("TSTObj2Model *", value.type)

    ###
    # obj2 model
    ###
    model = validate_model_files(models, "TSTObj2Model", ["TSTObj3Model"])

    # properties
    props = model[:h].properties

    key = props.shift
    assert_equal("key", key.name)
    assert_equal("NSString *", key.type)

    value = props.shift
    assert_equal("value", value.name)
    assert_equal("TSTObj3Model *", value.type)

    ###
    # obj3 model
    ###
    model = validate_model_files(models, "TSTObj3Model", [])

    # properties
    props = model[:h].properties

    key = props.shift
    assert_equal("key", key.name)
    assert_equal("NSString *", key.type)

    value = props.shift
    assert_equal("value", value.name)
    assert_equal("NSString *", value.type)
  end
end

