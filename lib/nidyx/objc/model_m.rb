require "nidyx/common"

include Nidyx::Common

module Nidyx
  class ModelM < ModelBase

    def initialize(name, options)
      super
      self.file_name = implementation_path(name)
      self.imports = [name]
    end
  end
end
