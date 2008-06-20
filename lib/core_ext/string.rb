# Emulates Source's behaviours, in order to allow the string handling
# (as RDF triple's objects) in the admin pane.
class String #:nodoc:
  def titleized #:nodoc:
    titleize
  end
  
  # TODO DRYup it's the same implementation of String#to_permalink
  # in talia_core/lib/core_ext/string.rb
  def uri #:nodoc:
    self.gsub(/\W+/, ' ').strip.downcase.titleize.gsub(/\ +/, '_')
  end
  
  # We can easily hardcode true, because this method
  # should be called only on page load.
  def exists? #:nodoc:
    true
  end
end
