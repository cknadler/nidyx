require 'json'

module Nidyx
  module SchemaReader
    extend self

    def read(path)
      begin
        # TODO: validate this is legitimate JSON Schema
        return JSON.parse(IO.read(path))
      rescue JSON::JSONError
        puts "Invalid JSON read from #{path}"
        exit 1
      rescue StandardError => e
        puts e.message
        exit 1
      end
    end
  end
end
