require "nidyx/objc/model_base"

module Nidyx
  class ObjCImplementation < ObjCModelBase
    self.template_file = File.join(self.template_path, "implementation.mustache")

    def initialize(name, options)
      super
      self.file_name = "#{name}.#{EXT}"
      self.imports = []
      add_json_model if options[:objc][:json_model]
      self.imports << name
    end

    private
    EXT = "m"
    JSON_MODEL_IMPORT = "JSONModel"

    def add_json_model
      self.imports << JSON_MODEL_IMPORT
    end
  end
end
