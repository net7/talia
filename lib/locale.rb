Globalize::Locale.class_eval do
  # Not Thread-safe
  def self.active
    @@active ||= begin
      code = base_language.code
      self.set code
      Locale.new code
    end
  end
end
