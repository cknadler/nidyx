module Nidyx
  module Common
    def class_name(prefix, key)
      if key
        prefix + key.camelize + "Model"
      else
        prefix + "Model"
      end
    end
  end
end
