require "nidyx/common"
require "nidyx/model_h"
require "nidyx/model_m"

include Nidyx::Common

module Nidyx
  class Generator
    attr_accessor :class_prefix, :options

    def initialize(class_prefix, options)
      @class_prefix = class_prefix
      @options = options
    end

    def spawn(schema)
      models = {}
      generate_model(schema["properties"], nil, schema, models)
      models
    end

    private

    # @param properties [Hash] the properties of the model to be generated
    # @param raw_name [String] the model's unformatted name, optional
    # @param schema [Hash] the full schema (for definition lookup)
    # @param models [Hash] a hash containing all of the generated models
    # (for model lookup)
    def generate_model(properties, raw_name, schema, models)
      name = class_name(self.class_prefix, raw_name)
      models[name] = {}
      generate_h(properties, name, schema, models)
      generate_m(name, models)
    end

    def generate_h(properties, name, schema, models)
      model = Nidyx::ModelH.new(name, self.options)
      properties.each { |k, v| generate_property(k, v, model, models) } if properties
      models[name][:h] = model
    end

    def generate_property(key, value, model, models)

    end

    def generate_m(name, models)
      models[name][:m] = Nidyx::ModelM.new(name, self.options)
    end
  end
end

# I have absolutely no idea.
