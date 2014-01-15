module Nidyx
  class Model
    attr_accessor :properties, :dependencies
    attr_reader :name

    def initialize(name)
      @name = name
      @properties = []
      @dependencies = Set.new
    end
  end
end
