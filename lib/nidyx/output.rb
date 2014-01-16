module Nidyx
  module Output
    extend self

    # @param models [Hash] a full hash of models to output
    # @param dir [String] output directory, defaults to current directory
    def write(models, dir)
      path = dir || Dir.getwd
      models.each { |m| write_file(model, path) }
    end

    private

    # @param model [Hash] all of the files for a specific model, stored in
    # @param path [String] output directory
    # a hash by extension
    def write_file(model, path)
      model.files.each do |file|
        File.open(File.join(path, file.file_name), "w") do |f|
          f.puts file.render
        end
      end
    end
  end
end
