module Platform # :nodoc:
  extend self

  def jruby?
    RUBY_PLATFORM =~ /java/
  end
end

extend Platform
