require "set"
require "nidyx/objc/model"
require "nidyx/objc/interface"
require "nidyx/objc/implementation"
require "nidyx/objc/property"

module Nidyx
  module ObjCMapper

    # Generates a list of ObjCModels
    # @param models [Array] an array of generic Models to map
    # @param options [Hash] runtime options
    # @return [Array] a list of ObjCModels
    def self.map(models, options)
      objc_models = []

      models.each do |m|
        interface = map_interface(m, options)
        implementation = map_implementation(m, options)
        objc_models << Nidyx::ObjCModel.new(interface, implementation)
      end

      objc_models
    end

    private

    def self.map_interface(model, options)
      interface = Nidyx::ObjCInterface.new(model.name, options)
      interface.properties = model.properties.map { |p| Nidyx::ObjCProperty.new(p) }
      dependencies = Nidyx::ObjCUtils.filter_standard_types(model.dependencies.to_a)
      interface.class_forward_declarations += dependencies
      interface.protocol_forward_declarations += dependencies
      interface
    end

    def self.map_implementation(model, options)
      implementation = Nidyx::ObjCImplementation.new(model.name, options)
      name_overrides = {}
      model.properties.each { |p| name_overrides[p.overriden_name] = p.name if p.overriden_name }
      implementation.name_overrides = name_overrides
      implementation
    end
  end
end
