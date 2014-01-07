require "minitest/autorun"
require "nidyx" # we use some core_ext stuff that requires this
require "nidyx/generator"

class TestGenerator < Minitest::Test
  def test_empty_schema
    schema = { "type" => "object" }

    begin
      run_generate(schema)
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

    models = run_generate(schema)
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

    models = run_generate(schema)
    model = validate_model_files(models, "TSTModel", [])

    # properties
    props = model[:h].properties

    key = props.shift
    assert_equal("key", key.name)
    assert_equal("NSString", key.type_name)
    assert_equal(nil, key.desc)

    value = props.shift
    assert_equal("value", value.name)
    assert_equal("NSString", value.type_name)
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

    models = run_generate(schema)

    ###
    # root model
    ###
    model = validate_model_files(models, "TSTModel", ["TSTValueModel"])

    # properties
    props = model[:h].properties

    key = props.shift
    assert_equal("key", key.name)
    assert_equal("NSString", key.type_name)

    value = props.shift
    assert_equal("value", value.name)
    assert_equal("TSTValueModel", value.type_name)

    ###
    # value model
    ###
    model = validate_model_files(models, "TSTValueModel", ["TSTValueObjModel"])

    # properties
    props = model[:h].properties

    name = props.shift
    assert_equal("name", name.name)
    assert_equal("NSString", name.type_name)

    obj = props.shift
    assert_equal("obj", obj.name)
    assert_equal("TSTValueObjModel", obj.type_name)

    ###
    # value obj model
    ###
    model = validate_model_files(models, "TSTValueObjModel", [])

    # properties
    props = model[:h].properties

    id = props.shift
    assert_equal("id", id.name)
    assert_equal("NSString", id.type_name)

    data = props.shift
    assert_equal("data", data.name)
    assert_equal("NSString", data.type_name)
  end

  def test_definitions
    schema = {
      "type" => "object",
      "properties" => {
        "value" =>  { "$ref" => "#/definitions/obj" },
      },
      "definitions" => {
        "obj" => {
          "type" => "object",
          "properties" => {
            "banner" => { "$ref" => "#/definitions/banner" },
            "count" => { "type" => "integer" }
          }
        },
        "banner" => { "type" => "string" }
      }
    }

    models = run_generate(schema)

    ###
    # root model
    ###
    model = validate_model_files(models, "TSTModel", ["TSTObjModel"])

    # properties
    props = model[:h].properties

    value = props.shift
    assert_equal("value", value.name)
    assert_equal("TSTObjModel", value.type_name)

    ###
    # obj model
    ###
    model = validate_model_files(models, "TSTObjModel", [])

    # properties
    props = model[:h].properties

    banner = props.shift
    assert_equal("banner", banner.name)
    assert_equal("NSString", banner.type_name)

    count = props.shift
    assert_equal("count", count.name)
    assert_equal("NSNumber", count.type_name)
  end

  def test_unsigned_integer
    schema = {
      "type" => "object",
      "required" => ["larger"],
      "properties" => {
        "value" => {
          "type" => "integer",
          "minimum" => 0
        },
        "larger" => {
          "type" => "integer",
          "minimum" => 100
        }
      }
    }

    models = run_generate(schema)
    model = models["TSTModel"]
    props = model[:h].properties

    value = props.shift
    assert_equal("NSNumber", value.type_name)

    larger = props.shift
    assert_equal("NSUInteger", larger.type_name)
  end

  def test_chained_refs
    schema = {
      "type" => "object",
      "properties" => {
        "value1" => { "$ref" => "#/definitions/value2" }
      },
      "definitions" => {
        "value2" => { "$ref" => "#/definitions/value3" },
        "value3" => { "type" => "string" }
      }
    }

    models = run_generate(schema)
    model = models["TSTModel"]
    props = model[:h].properties

    value1 = props.shift
    assert_equal("NSString", value1.type_name)
  end

  def test_chained_refs_to_an_object
    schema = {
      "type" => "object",
      "properties" => {
        "value1" => { "$ref" => "#/definitions/value2" }
      },
      "definitions" => {
        "value2" => { "$ref" => "#/definitions/value3" },
        "value3" => {
          "type" => "object",
          "properties" => {
            "value4" => { "type" => "string" }
          }
        }
      }
    }

    models = run_generate(schema)

    ###
    # root model
    ###
    model = models["TSTModel"]
    props = model[:h].properties

    value1 = props.shift
    assert_equal("TSTValue3Model", value1.type_name)

    ###
    # mid ref
    ###
    model = models["TSTValue2Model"] # this should never exist
    assert_equal(nil, model)

    ###
    # end ref
    ###
    model = models["TSTValue3Model"]
    props = model[:h].properties

    value4 = props.shift
    assert_equal("NSString", value4.type_name)
  end

  private

  CLASS_PREFIX = "TST"
  OPTIONS = {}

  def run_generate(schema)
    Nidyx::Generator.spawn(CLASS_PREFIX, OPTIONS, schema)
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
end
