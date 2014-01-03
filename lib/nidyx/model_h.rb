require "nidyx/model_base"
require "nidyx/common"

include Nidyx::Common

module Nidyx
  class ModelH < ModelBase
    attr_accessor :properties, :json_model

    def initialize(name, options)
      super
      self.file_name = header_path(name)
      self.properties = []
      self.json_model = options[:json_model]
      self.imports = []
    end
  end
end
