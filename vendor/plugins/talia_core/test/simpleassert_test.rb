require 'test/unit'
require File.dirname(__FILE__) + "/../lib/talia_core"

# Test the simple assert facility
class SimpleAssertTest < Test::Unit::TestCase
  def setup
    @@debug_old = $DEBUG # save the debug mode
  end
  
  def teardown
    $DEBUG = @@debug_old
  end
  
  # Tests the basic assert facility
  def test_assert
    $DEBUG = true
    sassert(true)
    assert_raise(AssertionFailure) { sassert(false, "boing") }
    $DEBUG = false
    sassert(false)
  end
  
  # Test nil assert
  def test_assert__not_nil
    $DEBUG = true
    not_nil = "xxx"
    sassert_not_nil(not_nil, "message")
    assert_raise(AssertionFailure) { sassert_not_nil(nil) }
  end
  
  # Test type assert
  def test_assert_type
    $DEBUG = true
    my_string = String.new
    my_hash = Hash.new
    
    sassert_type(my_string, Object)
    sassert_type(my_string, String, "message")
    assert_raise(AssertionFailure) { sassert_type(my_hash, String, "message") }
  end
  
end