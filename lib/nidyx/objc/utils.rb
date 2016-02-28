require "nidyx/objc/constants"

module Nidyx
  module ObjCUtils

    include Nidyx::ObjCConstants

    # Filters standard objc object types from an array of types. The result is
    # an array of non-standard object types. For example:
    #
    #   filter_standard_types(["AnObj", "string"]) #=> ["AnObject"]
    #   filter_standard_types(["string", "number_obj"]) #=> []
    #
    # @param type [Array[String|Symbol]] collection of any objc types
    # @return [Array[Symbol]] the collection w/o standard objc types
    def self.filter_standard_types(types)
      # TODO: throw an exception on primitives
      types.reject { |t| TYPES.keys.include?(t.to_sym) }
    end
  end
end
