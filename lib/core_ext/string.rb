class String
  def to_permalink
    self.gsub(/\W+/, ' ').strip.downcase.titleize.gsub(/\ +/, '_')
  end
end