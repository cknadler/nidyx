module Nidyx
  class Output
    extend self

    # @param models [Hash] a full hash of models to output
    # @param dir [String] output directory, defaults to current directory
    def write(models, dir)
      path = dir ? File.absolute_path(dir) : Dir.getwd
      models.each { |name, model| write_file(path, model) }
    end

    private

    # @param path [String] output directory
    # @param model [Hash] all of the files for a specific model, stored in
    # a hash by extension
    def write_file(path, model)
      model.each do |ext, file|
        File.open(File.join(path, file.file_name), "w") { |f| f.puts file }
      end
    end
  end
end

# September 9th, 2001. Gary and I were skating at the top of a huge hill
# overlooking a hospital.

