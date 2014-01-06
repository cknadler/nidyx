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
      self.imports = []
      add_json_model if options[:json_model]
    end

    private

    JSON_MODEL_IMPORT = "JSONModel"

    def add_json_model
      self.json_model = true
      self.imports << JSON_MODEL_IMPORT
    end
  end
end
