require "nidyx/objc/model_base"

module Nidyx
  class ObjCImplementation < ObjCModelBase
    self.template_file = File.join(self.template_path, "implementation.mustache")

    attr_accessor :name_overrides

    def initialize(name, options)
      super
      self.file_name = "#{name}.#{EXT}"
      self.imports = [name]
    end

    def name_overrides?
      !self.name_overrides.empty?
    end

    def name_override_string
      string = ""
      count = 0
      name_overrides.each do |original, override|
        count += 1
        string += "@\"#{original}\": @\"#{override}\""
        string += ",\n" unless count == name_overrides.length
      end
      string
    end

    private
    EXT = "m"
  end
end
