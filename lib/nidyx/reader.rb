require "json"
require "nidyx/parse_constants"

include Nidyx::ParseConstants

module Nidyx
  module Reader
    extend self

    class EmptySchemaError < StandardError; end

    # Reads JSON from a file
    # @param path [String] path of the file to read
    # @return [Hash] the parsed JSON
    def read(path)
      schema = nil

      begin
        # TODO: validate this is legitimate JSON Schema
        schema = JSON.parse(IO.read(path))
        raise EmptySchemaError if empty_schema?(schema)
      rescue JSON::JSONError => e
        puts "Encountered an error reading JSON from #{path}"
        puts e.message
        exit 1
      rescue EmptySchemaError
        puts "Schema read from #{path} is empty"
        exit 1
      rescue StandardError => e
        puts e.message
        exit 1
      end

      schema
    end

    # @param schema [Hash] an object containing JSON schema
    # @return [Boolean] true if the schema is empty
    def empty_schema?(schema)
      props = schema[PROPERTIES_KEY]
      items = schema[ITEMS_KEY]
      (!props || props.empty?) && (!items || items.empty?)
    end
  end
end
