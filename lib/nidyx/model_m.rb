module Nidyx
  class ModelM < ModelBase

    EXTENSION = ".m"

    def initialize(name, options)
      self.name = name
      self.file_name = name + EXTENSION
      self.author = options[:author]
      self.company = options[:company]
      self.project = options[:project]
    end

    def to_s
      self.header + self.imports_block + implementation
    end

    private

    def implementation
      """

      @implementation #{self.name}

      @end
      """
    end
  end
end
