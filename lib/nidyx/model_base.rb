module Nidyx
  class ModelBase
    attr_accessor :name, :file_name, :author, :company, :project, :imports

    def imports_block
      return nil unless self.imports
      block = ""
      self.imports.each { |i| block += "#import \"#{i}.h\"\n" }
      block
    end
  end
end
