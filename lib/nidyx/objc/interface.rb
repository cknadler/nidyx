require "nidyx/objc/model_base"

module Nidyx
  class ObjCInterface < ObjCModelBase
    attr_accessor :properties
    attr_reader :json_model

    def initialize(name, options)
      super
      self.file_name = "#{name}.#{EXT}"
      add_json_model if options[:json_model]
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
