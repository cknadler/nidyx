require "nidyx/objc/model"
require "nidyx/objc/interface"
require "nidyx/objc/implementation"

module Nidyx
  module ObjCMapper
    extend self

    # Generates a list of ObjCModels
    # @param models [Array] an array of generic Models to map
    # @param options [Hash] runtime options
    # @return [Array] a list of ObjCModels
    def map(models, options)
      objc_models = []

      models.each do |m|
        interface = map_interface(m, options)
        implementation = Nidyx::ObjCImplementation.new(m.name, options)
        objc_models << Nidyx::ObjCModel.new(interface, implementation)
      end
    end

    private

    def map_interface(model, options)
      interface = Nidyx::ObjCInterface.new(model.name, options)
      interface.properties = model.properties.map { |p| Nidyx::ObjCProperty.new(p) }
      interface.imports = model.dependencies
      interface
    end
  end
end
