require "set"
require "nidyx/objc/utils"

include Nidyx::ObjCUtils

module Nidyx
  class ObjCProperty

    attr_reader :name, :attributes, :type, :type_name, :desc, :getter_override,
                :protocols

    # @param property [Property] generic property
    def initialize(property)
      @name = property.name
      @optional = property.optional
      @desc = property.description

      @getter_override = process_getter_override(name)
      @type = process_type(property)
      @attributes = ATTRIBUTES[@type]
      @type_name = lookup_type_name(@type, property.class_name)

      @protocols = []
      # Exclude any primitive types for collections
      @protocols += filter_primitives(property.collection_types) if property.collection_types
      @protocols << "Optional" if @optional
    end

    # @return [Boolean] true if the obj-c property type is an object
    def is_obj?
      OBJECTS.include?(self.type)
    end

    # @return [Boolean] true if the property has protocols
    def has_protocols?
      !@protocols.empty?
    end

    # @return [String] the property's protocols, comma separated
    def protocols_string
      @protocols.join(", ")
    end
  end
end
