=begin
  This adds simple assert() functionality to the object class. It can be
  packagd into it's own gem and extended later.
  
  We call the functions "sassert*" to differentiate them from the unit
  test asserts.
  
  At the moment, it just raises an error in debug mode, and is ignored
  otherwise
=end

# Error class for the asserts
class AssertionFailure < StandardError
end

# Add the functionality to the objects
class Object
  
  # Standard assert
  def sassert(bool, message = "Assertion failed")
    if $DEBUG
      raise AssertionFailure.new(message) unless bool
    end
  end
  
  # Assert if an object is not nil
  def sassert_not_nil(object, message = "Object is nil")
    sassert(object != nil, message)
  end
  
  # Assert if something is of the right type
  def sassert_type(object, klass, message = "Object of wrong type")
    sassert(object.kind_of?(klass), message)
  end
end