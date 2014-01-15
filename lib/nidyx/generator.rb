require 'nidyx/reader'
require 'nidyx/parser'
require 'nidyx/mapper'
require 'nidyx/output'

module Nidyx
  module Generator
    extend self

    def run(schema_path, model_prefix, options)
      schema = Nidyx::Reader.read(schema_path)
      raw_models = Nidyx::Parser.parse(model_prefix, schema, options)
      models = Nidyx::Mapper.map(raw_models, options)
      Nidyx::Output.write(models)
    end
  end
end
