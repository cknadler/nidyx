require 'nidyx/reader'
require 'nidyx/parser'
require 'nidyx/mapper'
require 'nidyx/output'

module Nidyx
  module Generator
    extend self

    # The Nidyx model generator. Called by the Nidyx CLI. Parses the input
    # schema, creates models and writes them to the output directory.
    # @param schema_path [String] Path to the schema to generate models with.
    # @param options [Hash] Model generation options hash.
    def run(schema_path, options)
      schema = Nidyx::Reader.read(schema_path)
      raw_models = Nidyx::Parser.parse(schema, options)
      models = Nidyx::Mapper.map(raw_models, options)
      Nidyx::Output.write(models, options[:output_directory])
    end
  end
end
