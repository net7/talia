require 'test/unit'
require File.dirname(__FILE__) + "/../lib/talia_core"

# Load the helper class
require File.dirname(__FILE__) + '/test_helper'

module TaliaCore
  
  # Test the SourceRecord storage class
  class SourceRecordTest < Test::Unit::TestCase
 
    # Establish the database connection for the test
    TestHelper.startup
    
    def setup
      TestHelper.fixtures
      @test_record = SourceRecord.new("http://dummyuri.com/")
    end
    
    # Test the accessor methods for uri
    def test_uri
      @test_record.uri = "http://something.com/"
      assert_kind_of(N::URI, @test_record.uri)
      assert_equal("http://something.com/", @test_record.uri.to_s)
    end
    
    # Test the array-type accessor for uri
    def test_uri_arr
      @test_record[:uri] = "http://something.com/"
      assert_kind_of(N::URI, @test_record[:uri])
      assert_equal("http://something.com/", @test_record[:uri].to_s)
    end
    
    # Tests the exists_uri? method
    def test_exists_uri
      assert(SourceRecord.exists_uri?("http://localnode.org/something"))
      assert(!SourceRecord.exists_uri?("http://noexist/"))
    end
    
    # Tests the find_by_uri method
    def test_find_by_uri
      record = SourceRecord.find_by_uri("http://localnode.org/something")
      assert(record)
      assert_equal("http://localnode.org/something", record.uri.to_s)
    end
    
  end
end