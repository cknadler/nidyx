require "mustache"

module Nidyx
  class ObjCModelBase < Mustache
    attr_accessor :name, :file_name, :author, :owner, :project, :imports, :comments, :json_model

    self.template_path = File.join(__FILE__, "../../../../templates/objc")

    def initialize(name, options)
      @name = name
      @author = options[:author]
      @owner = options[:company]
      @project = options[:project]
      @comments = options[:comments]
      @json_model = options[:objc][:json_model] if options[:objc]
      @imports = []
    end

    def has_imports?
      !self.imports.empty?
    end

    def no_owner?
      !self.owner
    end

    def json_model?
      self.json_model
    end
  end
end
