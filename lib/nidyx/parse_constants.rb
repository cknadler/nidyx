module Nidyx
  module ParseConstants

    ###
    # Schema key definitions
    ###
    REF_KEY              = "$ref".freeze
    ENUM_KEY             = "enum".freeze
    TYPE_KEY             = "type".freeze
    DESCRIPTION_KEY      = "description".freeze
    REQUIRED_KEY         = "required".freeze
    PROPERTIES_KEY       = "properties".freeze
    NAME_OVERRIDE_KEY    = "nameOverride".freeze
    ITEMS_KEY            = "items".freeze
    MINIMUM_KEY          = "minimum".freeze
    ANY_OF_KEY           = "anyOf".freeze

    ###
    # Internal schema key definitions
    ###
    DERIVED_NAME         = "__derivedName".freeze
    COLLECTION_TYPES_KEY = "__collectionTypes".freeze

    ###
    # Object types
    ###
    OBJECT_TYPE = "object".freeze
    ARRAY_TYPE  = "array".freeze
  end
end
