module Nidyx
  module Common

    CLASS_SUFFIX = "Model"

    def class_name(prefix, key)
      if key
        prefix + key.camelize + CLASS_SUFFIX
      else
        prefix + CLASS_SUFFIX
      end
    end

    def header_path(name)
      name + ".h"
    end

    def implementation_path(name)
      name + ".m"
    end
  end
end
