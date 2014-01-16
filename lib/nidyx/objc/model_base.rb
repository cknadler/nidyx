require "mustache"

module Nidyx
  class ObjCModelBase < Mustache
    attr_accessor :name, :file_name, :author, :owner, :project, :imports, :comments

    self.template_path = File.join(__FILE__, "../../../../templates/objc")

    def initialize(name, options)
      @name = name
      @author = options[:author] || ENV['USER']
      @owner = options[:company] || @author
      @project = options[:project]
      @comments = options[:comments]
      @imports = []
      @time = Time.now
    end

    def created_date
      @time.strftime("%m/%d/%Y")
    end

    def created_year
      @time.year
    end

    def has_imports?
      !imports.empty?
    end
  end
end
