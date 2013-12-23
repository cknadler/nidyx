module Nidyx
  class Generator
    attr_reader :author, :company, :project, :json_model, :output_directory,
      :class_prefix, :schema

    def initialize(class_prefix, output_directory, options)
      @class_prefix = class_prefix
      @output_directory = output_directory
      @author = options[:author]
      @company = options[:company]
      @project = options[:project]
      @json_model = options[:json_model]
    end

    def spawn(schema)
      puts schema
    end

    def class_name(prefix, key)
      key.nil? ? "#{prefix}Model" : "#{prefix + key}Model"
    end
  end
end
