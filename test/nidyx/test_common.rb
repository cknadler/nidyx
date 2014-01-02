require "minitest/autorun"
require "nidyx"
require "nidyx/common"

include Nidyx::Common

class TestCommon < Minitest::Test
  def test_class_name
    assert_equal("DKResponseModel", class_name("DK", "response"))
    assert_equal("DKModel", class_name("DK", nil))
    assert_equal("DKLargeButtonModel", class_name("DK", "large_button"))
  end

  def test_class_name_from_path
    path = ["properties", "obj", "properties", "value"]
    assert_equal("DKObjValueModel", class_name_from_path("DK", path))

    path = ["definitions", "obj", "properties", "value"]
    assert_equal("DKObjValueModel", class_name_from_path("DK", path))

    assert_equal("DKModel", class_name_from_path("DK", []))
  end

  def test_header_path
    name = "DKModel"
    assert_equal(name + ".h", header_path(name))
  end

  def test_implementation_path
    name = "DKModel"
    assert_equal(name + ".m", implementation_path(name))
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

    obj = object_at_path(["properties", "value"], schema)
    assert_equal("#/definitions/obj", obj["$ref"])

    obj = object_at_path(["definitions", "obj"], schema)
    assert_equal("object", obj["type"])
    assert_equal("string", obj["properties"]["name"]["type"])

    obj = object_at_path(["definitions", "obj", "properties", "count"], schema)
    assert_equal("integer", obj["type"])
  end
end
