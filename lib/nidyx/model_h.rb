module Nidyx
  class ModelH < ModelBase
    attr_accessor :properties, :json_model

    def to_s
      super.header + super.imports_block + interface + properties_block
    end

    private

    def interface
      """

      @interface #{super.name}#{": JSONModel" if self.json_model}

      """
    end

    def properties_block
      block = ""
      self.properties.each { |p| block += p.to_s }
      block + "\n@end"
    end
  end
end
