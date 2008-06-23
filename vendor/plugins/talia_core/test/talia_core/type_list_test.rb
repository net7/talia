require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  
  # Test the SourceRecord storage class
  class TypeListTest < Test::Unit::TestCase
 
    # Establish the database connection for the test
    TestHelper.startup
    
    def setup
      TestHelper.flush_db
      @record = SourceRecord.new("http://dummyuri.com/")
      @record.name = '0'
      @record.primary_source = false
      @record.save!
      @test_list = TypeList.new(@record.type_records)
      @record.type_records.clear
    end
    
    # Test add operation
    def test_add
      @test_list << "http://foo.com/type"
      assert_equal(1, @test_list.size)
    end
    
    # Test save operation
    def test_save
      @test_list << "http://foo.com/saved"
      @record.save!
      rec2 = SourceRecord.find_by_uri(@record.uri)
      assert_equal(1, rec2.type_records.size)
    end
    
    # Test the remove operation
    def test_remove
      @test_list << "http://foobar.com/deleteme"
      @record.save!
      @test_list.remove("http://foobar.com")
      rec2 = SourceRecord.find_by_uri(@record.uri)
      assert_equal(1, rec2.type_records.size)
    end
    
    # Test the accessor
    def test_access
      @test_list << "http://foobar.com/accessme"
      assert_kind_of(N::SourceClass, @test_list[0])
      assert_equal("http://foobar.com/accessme", @test_list[0].to_s)
    end
  end
end