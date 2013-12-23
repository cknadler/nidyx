class String
  def camelize
    s = self.sub(/^[a-z\d]*/) { $&.capitalize }
    s.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
  end
end
