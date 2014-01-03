require "mustache"

module Nidyx
  class ModelBase < Mustache
    self.template_path = "lib"
    attr_accessor :name, :file_name, :author, :owner, :project, :imports

    def initialize(name, options)
      @name = name
      @author = options[:author] || ENV['USER']
      @owner = options[:company] || @author
      @project = options[:project]
    end

    def created_date
      Time.now.strftime("%m/%d/%Y")
    end

    def created_year
      Time.now.year
    end
  end
end
