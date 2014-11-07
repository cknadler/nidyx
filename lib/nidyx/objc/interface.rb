require "nidyx/objc/model_base"

module Nidyx
  class ObjCInterface < ObjCModelBase
    attr_accessor :properties

    self.template_file = File.join(self.template_path, "interface.mustache")

    def initialize(name, options)
      super
      self.file_name = "#{name}.#{EXT}"
      self.imports << JSON_MODEL_IMPORT if self.json_model
    end

    private
    EXT = "h"
    JSON_MODEL_IMPORT = "JSONModel"

  end
end
