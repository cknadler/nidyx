module Nidyx
  class ObjCModel
    def initialize(interface, implementation)
      @interface = interface
      @implementation = implementation
    end

    def files
      [@interface, @implementation]
    end
  end
end
