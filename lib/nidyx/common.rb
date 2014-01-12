module Nidyx
  module Common
    class NoObjectAtPathError < StandardError; end

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

      begin
        path.each { |p| obj = obj[p] }
      rescue
        raise NoObjectAtPathError, path
      end

      raise NoObjectAtPathError, path unless obj

      obj
    end
  end
end
