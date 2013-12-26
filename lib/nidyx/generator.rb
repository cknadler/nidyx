require "nidyx/common"
require "nidyx/model_h"
require "nidyx/model_m"

include Nidyx::Common

module Nidyx
  class Generator
    attr_accessor :class_prefix, :output_directory, :options

    attr_reader :models, :schema

    def initialize(class_prefix, output_directory, options)
      @class_prefix = class_prefix
      @options = options
      @output_directory = File.absolute_path(output_directory) if output_directory
    end

    def spawn(schema)
      @schema = schema
      @models = {}
      generate_model(schema["properties"], nil)

      self.models.each do |name, files|
        output_file(files[:m].file_name, files[:m])
      end
    end

    private

    def generate_model(properties, raw_name)
      name = class_name(self.class_prefix, raw_name)
      self.models[name] = {}
      generate_h(properties, name)
      generate_m(name)
    end

    def generate_h(properties, name)
      model = Nidyx::ModelH.new(name, self.options)

      properties.each do |property|

      end

      self.models[name][:h] = model
    end

    def generate_m(name)
      model = Nidyx::ModelM.new(name, self.options)
      self.models[name][:m] = model
    end

    def output_file(name, file)
      path = self.output_directory ? File.join(self.output_directory, name) : name
      File.open(path, "w") { |f| puts file }
    end
  end
end
