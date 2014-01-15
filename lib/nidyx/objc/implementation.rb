require "nidyx/objc/model_base"

module Nidyx
  class ObjCImplementation < ObjCModelBase

    def initialize(name, options)
      super
      self.file_name = "#{name}.#{EXT}"
      self.imports = [name]
    end

    private

    EXT = "m"
  end
end
