class String
  # Inspired by (read: "Stolen from") Rails ActiveSupport::Inflector
  def camelize(uppercase_first_letter = true)
    s = self
    if uppercase_first_letter
      s = s.sub(/^[a-z\d]*/) { $&.capitalize }
    else
      s = s.sub(/^([A-Z_]|\w)/) { $&.downcase }
    end
    s.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
  end
end
