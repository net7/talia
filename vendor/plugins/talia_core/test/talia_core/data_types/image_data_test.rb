require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

module TaliaCore

  # Test te DataRecord storage class
  class ImageDataTest < Test::Unit::TestCase
  
    # Establish the database connection for the test
    TestHelper.startup
     
    def setup
      TestHelper.fixtures
      @test_records = DataRecord.find_data_records(1)
    end
    
    # test not nil and records numbers
    def test_records_numbers
      assert_not_equal [], @test_records
      assert_equal 13, @test_records.size
    end
  
    # test class type and mime_type and subtype
    def test_mime_types
      assert_kind_of(ImageData, @test_records[7])
      assert_kind_of(ImageData, @test_records[8])
      assert_kind_of(ImageData, @test_records[9])
      assert_kind_of(ImageData, @test_records[10])
      assert_kind_of(ImageData, @test_records[11])
      assert_kind_of(ImageData, @test_records[12])
      assert_equal("image/bmp", @test_records[7].mime_type)
      assert_equal("image/fits", @test_records[8].mime_type)
      assert_equal("image/gif", @test_records[9].mime_type)
      assert_equal("image/jpeg", @test_records[10].mime_type)
      assert_equal("image/png", @test_records[11].mime_type)
      assert_equal("image/tiff", @test_records[12].mime_type)
    end
    
    # test data directory
    def test_data_directory
      base_dir_name = File.expand_path(File.join(File.dirname(__FILE__), '..', '..' , 'data_for_test', 'ImageData'))
      dir_for_test  = File.expand_path(@test_records[7].data_directory)
      assert_equal(base_dir_name, dir_for_test)
      assert(File.exists?(dir_for_test))
      assert_equal(File.join(base_dir_name, 'temp1.bmp'), File.join(dir_for_test, @test_records[7].location))
      assert( File.exists?(File.join(dir_for_test, @test_records[7].location)), "#{File.join(dir_for_test, @test_records[7].location)} does not exist" )
    end

    # test file size
    def test_file_size
      assert_equal(1254, @test_records[7].size)
    end
    
    # test binary access
    def test_binary_access
      # Check initial position
      assert_equal(0, @test_records[7].position)
      
      # Try to read all bytes
      bytes = @test_records[7].all_bytes
      assert_equal(1254, bytes.size)
      assert_equal(false, @test_records[7].is_file_open?)

      
      # Re-check position (it should be 0)
      assert_equal(0, @test_records[7].position)
    end
    
  end
end

