require "nidyx/objc/model_base"

module Nidyx
  class ObjCInterface < ObjCModelBase
    attr_accessor :properties

    self.template_file = File.join(self.template_path, "interface.mustache")

    def initialize(name, options)
      super
      self.file_name = "#{name}.#{EXT}"
      @json_model = options[:objc][:json_model]
    end

    def json_model?
      @json_model
    end

    private
    EXT = "h"
  end
end
