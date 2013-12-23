module Nidyx
  class Generator
    attr_reader :author, :company, :project, :json_model, :output_directory, :class_prefix

    def initialize(class_prefix, options, output_directory)
      @class_prefix = class_prefix
      @options = options
      @output_directory = output_directory
    end

    def generate(schema)
    end
  end
end
