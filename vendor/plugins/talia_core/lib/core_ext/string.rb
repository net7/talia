class String
  # Transform the current string into a permalink.
  def to_permalink
    self.gsub(/\W+/, ' ').strip.downcase.titleize.gsub(/\ +/, '_')
  end
end