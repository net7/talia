require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

module TaliaCore
  
  # Test the SourceRecord storage class
  class SourceRecordTest < Test::Unit::TestCase
 
    # Establish the database connection for the test
    TestHelper.startup
    
    def setup
      TestHelper.fixtures
      @test_record = SourceRecord.new("http://dummyuri.com/")
      
      setup_once(:local_source) do
        local_source = Source.new(N::LOCAL + "home_source")
        local_source.name = '42'
        local_source.primary_source = false
        local_source.save!
        local_source
      end
    end
    
    def _ignore_test_data
      assert_equal(Source.find(:first).data, Source.find(:first).instance_variable_get(:@data_record).data)
    end
    
    def test_titleized
      assert_equal("Home Source", @local_source.titleized)
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
    
    # Test failure mode of find_by_uri
    def test_find_by_uri_fail_none
      assert_raise(ActiveRecord::RecordNotFound) { SourceRecord.find_by_uri() }
    end
    
    # Tests the find_by_uri method
    def test_find_by_uri
      record = SourceRecord.find_by_uri("http://localnode.org/something")
      assert(record)
      assert_equal("http://localnode.org/something", record.uri.to_s)
    end
    
    # Tests the find_by_uri method when the uri is a single-element array
    def test_find_by_uri_single_array
      record = SourceRecord.find_by_uri(["http://localnode.org/something"])
      assert(record)
      assert_equal("http://localnode.org/something", record.uri.to_s)
    end
    
    # Test find_by_uri with multiple uris
    def test_find_by_multi_uri
      records = SourceRecord.find_by_uri("http://localnode.org/something", "http://localnode.org/otherthing")
      assert_kind_of(Array, records)
      assert_equal(2, records.size)
    end
    
    # Test find_by_uri with multiple uris (in array)
    def test_find_by_multi_uri
      records = SourceRecord.find_by_uri(["http://localnode.org/something", "http://localnode.org/otherthing"])
      assert_kind_of(Array, records)
      assert_equal(2, records.size)
    end
    
    # Test if multi-uri-find fails correctly
    def test_find_by_multi_uri_fail
      assert_raise(ActiveRecord::RecordNotFound) {SourceRecord.find_by_uri("http://localnode.org/something", "http://poop")}
    end
    
  end
end