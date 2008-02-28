require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

module TaliaCore
  
  # Test the SourceRecord storage class
  class DirtyRelationRecordTest < Test::Unit::TestCase
 
    # Establish the database connection for the test
    TestHelper.startup
    
    def setup
      TestHelper.fixtures
      @test_record = DirtyRelationRecord.new("http://dummyuri.com/")
    end
    
    # Test the accessor methods for uri
    def test_uri
      @test_record.uri = "http://something.com/"
      assert_kind_of(N::URI, @test_record.uri)
      assert_equal("http://something.com/", @test_record.uri.to_s)
    end
    
  end
end