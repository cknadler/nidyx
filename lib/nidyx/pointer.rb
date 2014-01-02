# JSON Pointer
module Nidyx
  class Pointer
    attr_reader :source, :path

    def initialize(str)
      match = /^(?<source>.*)#\/*(?<path>.*)$/.match(str)
      @source = match[:source]
      @path = match[:path].split("/")
    end

    def to_s
      puts "source: #{source}"
      puts "path: #{path}"
    end
  end
end
