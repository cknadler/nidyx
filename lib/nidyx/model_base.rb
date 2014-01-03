require "mustache"

module Nidyx
  class ModelBase < Mustache
    self.template_path = "lib"
    attr_accessor :name, :file_name, :author, :company, :project, :imports
  end
end
