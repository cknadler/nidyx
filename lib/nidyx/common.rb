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
      override = object_at_path(path, schema)[NAME_OVERRIDE_KEY]
      return class_name(prefix, override.camelize) if override

      name = ""
      path.each_index do |idx|
        # skip ignored keys such as "properties" in the name
        next if IGNORED_KEYS.include?(path[idx])
        # skip the last key if we are using an override
        next if override && (idx == path.length - 1)

        obj = object_at_path(path[0..idx], schema)
        if obj[NAME_OVERRIDE_KEY]
          name << obj[NAME_OVERRIDE_KEY].camelize
        else
          name << path[idx].camelize
        end
      end

      # append the override name to the end if present
      name << override.camelize if override
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
