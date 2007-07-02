require 'test/unit'
require File.dirname(__FILE__) + "/../lib/talia_core"
module TaliaCore
  
  # Test the uri class
  class URITest < Test::Unit::TestCase
    
    def setup
      @@local_domain = "http://www.samplething.com/"
      Configuration.local_node = URI.new(@@local_domain)
    end
    
    # Basic test for uri class
    def test_uri
      uri_string = "http://foobar.com/xyz/"
      uri = URI.new(uri_string)
      assert_equal(uri_string, uri.to_s)
      assert_equal(uri_string, uri.uri_s)
    end
    
    # Test local and remote checks
    def test_local_remote
      local_string = @@local_domain + "/myid"
      remote_string = "http://www.remote.com/something"
      
      
      domain = URI.new(@@local_domain)
      local = URI.new(local_string)
      remote = URI.new(remote_string)
      
      assert(local.local?)
      assert(!local.remote?)
      assert(remote.remote?)
      assert(!remote.local?)
      assert(domain.local?)
    end
    
    # Tests the equality operator
    def test_equality
     uri_string = "http://foobar.com/xyz/"
     uri = URI.new(uri_string)
     uri_2 = URI.new(uri_string)
     uri_other = URI.new("http://otheruri.com/")
     
     assert_equal(uri, uri_string)
     assert_equal(uri, uri)
     assert_equal(uri, uri_2)
     assert_not_equal("http://something.org", uri)
     assert_not_equal(uri, uri_other)
     assert_not_equal(uri, Hash.new)
    end
    
    # Tests the domain_of operation
    def test_domain_of
      local_string = @@local_domain + "/myid"
      remote_string = "http://www.remote.com/something"
      
      local_domain = URI.new(@@local_domain)
      local = URI.new(local_string)
      remote = URI.new(remote_string)
      
      assert(local.domain_of?(local))
      assert(local.domain_of?(local_string))
      assert(local_domain.domain_of?(local))
      assert(local_domain.domain_of?(local_string))
      
      assert(!local.domain_of?(local_domain))
      assert(!local.domain_of?(remote))
      assert(!local.domain_of?(remote_string))
      assert(!remote.domain_of?(local))
    end
    
    # Test the easy accessors
    def test_easy_accessors
      domain = URI.new(@@local_domain)
      assert_equal(@@local_domain + "foo", domain.foo)
      assert_equal(@@local_domain + "foo", domain::foo)
      assert_equal(@@local_domain + "FoO", domain.FoO)
      assert_raise(NoMethodError) { domain.foo(12) }
    end
    
  end
end