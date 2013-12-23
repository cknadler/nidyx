module Nidyx
  class ModelM < ModelBase
    def to_s
      super.header + super.imports_block + implementation
    end

    private

    def implementation
      """

      @implementation #{super.name}

      @end
      """
    end
  end
end
