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

    def class_name_from_path(prefix, path, schema)
      override = object_at_path(path, schema)["className"]
      return class_name(prefix, override) if override

      name = ""
      path.each { |p| name << p.camelize unless IGNORED_KEYS.include?(p) }
      class_name(prefix, name)
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
