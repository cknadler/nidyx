require "nidyx/objc/model_base"

module Nidyx
  class ObjCImplementation < ObjCModelBase
    self.template_file = File.join(self.template_path, "implementation.mustache")

    def initialize(name, options)
      super
      self.file_name = "#{name}.#{EXT}"
      self.imports = [name]
    end

    private
    EXT = "m"
  end
end
