module Nidyx
  module Common

    CLASS_SUFFIX = "Model"
    IGNORED_KEYS = "properties", "definitions"

    def class_name(prefix, key)
      if key
        prefix + key.camelize + CLASS_SUFFIX
      else
        prefix + CLASS_SUFFIX
      end
    end

    def class_name_from_path(prefix, path)
      name = ""
      path.each { |p| name += p.camelize unless IGNORED_KEYS.include?(p) }
      prefix + name + CLASS_SUFFIX
    end

    def header_path(name)
      name + ".h"
    end

    def implementation_path(name)
      name + ".m"
    end

    def object_at_path(path, schema)
      obj = schema
      path.each { |p| obj = obj[p] }
      obj
    end
  end
end
