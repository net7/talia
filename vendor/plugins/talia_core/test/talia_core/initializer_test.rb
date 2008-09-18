require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  
  # Just test if the initializer has works correctly
  class InitTest < Test::Unit::TestCase

    # Test it
    def test_initialized
      assert(TaliaCore::Initializer.initialized)
    end
    
    # Test namespaces
    def test_namespaces
      assert_equal(N::LOCAL.to_s, "http://localnode.org/")
      assert_equal(N::DEFAULT.to_s, "http://default.talia.eu/")
      assert_equal(N::FOO.to_s, "http://foo.com/")
      assert_kind_of(N::Namespace, N::FOO)
    end
    
    # Test the datase connection
    def test_db_connection
      assert(Source.exists?("http://localnode.org/something"))
    end
    
    def test_core_ext_loading
      assert 'string'.respond_to?(:to_permalink)
    end
  end
end