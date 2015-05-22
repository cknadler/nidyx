require "minitest/autorun"
require "nidyx"
require "nidyx/common"

include Nidyx::Common

class TestCommon < Minitest::Test
  def test_class_name
    assert_equal("DKResponseModel", class_name("DK", "response"))
    assert_equal("DKModel", class_name("DK", nil))
    assert_equal("DKLargeButtonModel", class_name("DK", "large_button"))
    assert_equal("Model", class_name(nil, nil))
  end

  def test_class_name_from_path
    schema = {
      "type" => "object",
      "properties" => {
        "obj" => { "$ref" => "#/definitions/obj" }
      },
      "definitions" => {
        "obj" => {
          "type" => "object",
          "properties" => {
            "name" => { "type" => "string" }
          }
        }
      }
    }

    path = ["definitions", "obj"]
    assert_equal("DKObjModel", class_name_from_path("DK", path, schema))
    # empty
    assert_equal("DKModel", class_name_from_path("DK", [], schema))
  end

  def test_class_name_from_path_overrides
    schema = {
      "type" => "object",
      "properties" => {
        "obj" => {
          "type" => "object",
          "nameOverride" => "otherObject",
          "properties" => {
            "subObject" => {
              "type" => "object",
              "nameOverride" => "otherSubObject",
              "properties" => {
                "count" => { "type" => "integer" }
              }
            }
          }
        }
      }
    }

    path = ["properties", "obj"]
    assert_equal("DKOtherObjectModel", class_name_from_path("DK", path, schema))
    path = ["properties", "obj", "properties", "subObject"]
    assert_equal("DKOtherSubObjectModel", class_name_from_path("DK", path, schema))
  end

  def test_object_at_path
    schema = {
      "type" => "object",
      "properties" => {
        "value" =>  { "$ref" => "#/definitions/obj" }
      },
      "definitions" => {
        "obj" => {
          "type" => "object",
          "properties" => {
            "name" => { "type" => "string" },
            "count" => { "type" => "integer" }
          }
        }
      }
    }

    obj = object_at_path(["properties", "value"], schema)
    assert_equal("#/definitions/obj", obj["$ref"])

    obj = object_at_path(["definitions", "obj"], schema)
    assert_equal("object", obj["type"])
    assert_equal("string", obj["properties"]["name"]["type"])

    obj = object_at_path(["definitions", "obj", "properties", "count"], schema)
    assert_equal("integer", obj["type"])
  end

  def test_object_at_path_raises
    schema = {
      "type" => "object",
      "properties" => {
        "value" => { "type" => "string" }
      }
    }

    assert_raises(Nidyx::Common::NoObjectAtPathError) do
      object_at_path(["bad", "path"], schema)
    end
  end
end
