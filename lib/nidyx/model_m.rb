require "nidyx/common"

include Nidyx::Common

module Nidyx
  class ModelM < ModelBase

    def initialize(name, options)
      self.name = name
      self.file_name = implementation_path(name)
      self.author = options[:author]
      self.company = options[:company]
      self.project = options[:project]
      self.imports = [name]
    end
  end
end
