require "mustache"

module Nidyx
  class ObjCModelBase < Mustache
    self.template_path = File.join(File.dirname(__FILE__), "..")
    attr_accessor :name, :file_name, :author, :owner, :project, :imports, :comments

    def initialize(name, options)
      @name = name
      @author = options[:author] || ENV['USER']
      @owner = options[:company] || @author
      @project = options[:project]
      @comments = options[:comments]
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
