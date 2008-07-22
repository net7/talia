require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

module TaliaCore

  # Test te DataRecord storage class
  class ImageDataTest < Test::Unit::TestCase
  
    fixtures :active_sources, :data_records
     
    def setup
      @test_records = DataTypes::DataRecord.find_data_records(Fixtures.identify(:something))
    end
    
    # test not nil and records numbers
    def test_records_numbers
      assert_not_equal [], @test_records
      assert_equal 13, @test_records.size
    end
  
    # test class type and mime_type and subtype
    def test_mime_types
      assert_kind_of(DataTypes::ImageData, @test_records[7])
      assert_kind_of(DataTypes::ImageData, @test_records[8])
      assert_kind_of(DataTypes::ImageData, @test_records[9])
      assert_kind_of(DataTypes::ImageData, @test_records[10])
      assert_kind_of(DataTypes::ImageData, @test_records[11])
      assert_kind_of(DataTypes::ImageData, @test_records[12])
      assert_equal("image/bmp", @test_records[7].mime_type)
      assert_equal("image/fits", @test_records[8].mime_type)
      assert_equal("image/gif", @test_records[9].mime_type)
      assert_equal("image/jpeg", @test_records[10].mime_type)
      assert_equal("image/png", @test_records[11].mime_type)
      assert_equal("image/tiff", @test_records[12].mime_type)
    end
    
    # test data directory
    def test_data_directory
      #base_dir_name = File.expand_path(File.join(File.dirname(__FILE__), '..', '..' , 'data_for_test', 'ImageData'))
      dir_for_test  = File.expand_path(@test_records[7].data_directory)
      assert_equal(base_dir_name(@test_records[7].id), dir_for_test)
      assert(File.exists?(dir_for_test))
      assert_equal(File.join(base_dir_name(@test_records[7].id), 'temp1.bmp'), File.join(dir_for_test, @test_records[7].location))
      assert( File.exists?(File.join(dir_for_test, @test_records[7].id.to_s)), "#{File.join(dir_for_test, @test_records[7].location)} does not exist" )
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
    
    def test_attach_image
      test_uri = 'http://testy.com/image_attach'
      src = Source.new(test_uri)
      data_record = DataTypes::ImageData.new do |dr|
        dr.location = 'my_file.jpg'
      end
      src.data_records << data_record
      src.save!
      rel = Source.find(src.id)
      assert_equal(1, rel.data_records.size)
      assert_kind_of(DataTypes::ImageData, rel.data_records[0])
    end
        
    private
    def base_dir_name(id=nil)
      @data_path_test ||= File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'data_for_test', 'ImageData', ("00" + id.to_s)[-3..-1]))
    end
  end
end

