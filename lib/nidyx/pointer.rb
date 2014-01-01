# JSON Pointer
module Nidyx
  class Pointer
    attr_reader :source, :path

    def initialize(str)
      match = /^(?<source>.*)#(?<path>.*)$/.match(str)
      @source = match[:source]
      @path = match[:path].split("/")
    end
  end
end
