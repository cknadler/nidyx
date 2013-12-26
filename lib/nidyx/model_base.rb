module Nidyx
  class ModelBase
    attr_accessor :name, :file_name, :author, :company, :project, :imports

    # TODO: fail gracefully if project, etc aren't present
    def header
      """
      //
      // #{self.file_name}
      // #{self.project}
      //
      // Created by #{self.author} on #{Time.now.strftime("%m/%d/%Y")}
      // Copyright (c) #{Time.now.year} #{self.company}. All rights reserved.
      //

      """
    end

    def imports_block
      block = ""
      self.imports.each { |i| block += "#import \"#{i}.h\"\n" }
      block
    end
  end
end
