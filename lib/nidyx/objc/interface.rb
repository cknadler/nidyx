require "nidyx/objc/model_base"

module Nidyx
  class ObjCInterface < ObjCModelBase
    attr_accessor :properties, :json_model, :protocol_definitions

    self.template_file = File.join(self.template_path, "interface.mustache")

    def initialize(name, options)
      super
      self.file_name = "#{name}.#{EXT}"
      add_json_model if options[:objc][:json_model]
    end

    def has_protocol_definitions?
      !self.protocol_definitions.empty?
    end

    private

    EXT = "h"
    JSON_MODEL_IMPORT = "JSONModel"

    def add_json_model
      self.json_model = true
      self.imports << JSON_MODEL_IMPORT
    end
  end
end
