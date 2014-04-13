require 'json'

module Nidyx
  module Reader
    extend self

    # Reads JSON from a file
    # @param path [String] path of the file to read
    # @return [Hash] the parsed JSON
    def read(path)
      begin
        # TODO: validate this is legitimate JSON Schema
        JSON.parse(IO.read(path))
      rescue JSON::JSONError => e
        puts "Encountered an error reading JSON from #{path}"
        puts e.message
        exit 1
      rescue StandardError => e
        puts e.message
        exit 1
      end
    end
  end
end
