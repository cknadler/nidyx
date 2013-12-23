require "nidyx/common"

include Nidyx::Common

module Nidyx
  class Generator
    attr_reader :author, :company, :project, :json_model, :output_directory,
      :class_prefix, :schema, :classes

    def initialize(class_prefix, output_directory, options)
      @class_prefix = class_prefix
      @output_directory = output_directory
      @author = options[:author]
      @company = options[:company]
      @project = options[:project]
      @json_model = options[:json_model]
      @classes = []
    end

    def spawn(schema)
      @schema = schema
      puts schema
    end

    def spawn_h

    end

  end
end
