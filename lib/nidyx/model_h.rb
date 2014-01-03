require "nidyx/model_base"
require "nidyx/common"

include Nidyx::Common

module Nidyx
  class ModelH < ModelBase
    attr_accessor :properties, :json_model

    EXTENSION = ".h"

    def initialize(name, options)
      self.name = name
      self.file_name = header_name(name)
      self.author = options[:author]
      self.company = options[:company]
      self.project = options[:project]
      self.properties = {}
      self.json_model = options[:json_model]
      self.imports = []
    end

    def to_s
      self.header + self.imports_block + interface + properties_block
    end

    private

    def interface
      """

      @interface #{self.name}#{": JSONModel" if self.json_model}

      """
    end

    def properties_block
      block = ""
      self.properties.each { |p| block += p.to_s }
      block + "\n@end"
    end
  end
end
