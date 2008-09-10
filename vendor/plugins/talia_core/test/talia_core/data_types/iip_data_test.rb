require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

module TaliaCore
  module DataType
    
    # Test the DataRecord storage class
    class IipDataTest < Test::Unit::TestCase
    
      fixtures :active_sources, :data_records
  
      def setup
        # Sets the file that is used by one test
        @test_records = DataTypes::DataRecord.find_data_records(Fixtures.identify(:something))
      end
      
      def teardown
        # remove all subdirectory of iip root
        Dir.foreach(TaliaCore::CONFIG["iip_root_directory_location"]) do |entry|
          unless ['.', '..', '.svn'].include? entry
            FileUtils.remove_dir File.join(TaliaCore::CONFIG["iip_root_directory_location"], entry)
          end
        end
      end
      
      # test not nil and records numbers
      def test_records_numbers
        assert_not_equal [], @test_records
        assert_equal 15, @test_records.size
      end
      
      # test class type and mime_type and subtype
      def test_mime_types
        assert_kind_of DataTypes::IipData, @test_records[14]
        assert_equal 'image/tiff', @test_records[14].mime_type
      end
    
      # test data directory
      def test_data_directory
        dir_for_test  = File.expand_path(@test_records[14].data_directory)
        assert_equal(base_dir_name(@test_records[14].id), dir_for_test)
        assert(File.exists?(dir_for_test))
        assert_equal('PATH/TO/IIPSERVER', @test_records[14].location)
        assert_equal('PATH/TO/IIPSERVER', @test_records[14].iip_server_path)
        assert(File.exists?(File.join(dir_for_test, @test_records[14].id.to_s)), "#{File.join(dir_for_test, @test_records[14].id.to_s)} does not exist" )
      end
      
      # test file size
      def test_file_size
        assert_equal(711, @test_records[14].size)
      end
      
      # test binary access
      def test_binary_access
        # Check initial position
        assert_equal(0, @test_records[14].position)
      
        # Try to read all bytes
        bytes = @test_records[14].all_bytes
        assert_equal(711, bytes.size)
        assert_equal(false, @test_records[14].is_file_open?)

        # Try to read all bytes by alias method
        bytes = @test_records[14].get_thumbnail
        assert_equal(711, bytes.size)
        assert_equal(false, @test_records[14].is_file_open?)
      
        # Re-check position (it should be 0)
        assert_equal(0, @test_records[14].position)
      end
      
      # test create from data method
      def test_create_from_data
        data = @test_records[14].all_text
        
        new_record = DataTypes::IipData.new
        new_record.source_id = "something"
        new_record.create_from_data('', data)
        new_record.save!
        
        # Try to read all bytes by alias method
        bytes = new_record.get_thumbnail
        assert(bytes.size > 100)
        assert_equal(false, new_record.is_file_open?)
        # Check if the mime was written correctly
        assert_equal('image/jpeg', DataTypes::IipData.find(new_record.id).mime_type)
        
        # delete record and file
        File.delete(new_record.get_file_path)
        Dir.delete new_record.data_directory
        DataTypes::IipData.delete new_record.id
      end
          
      private
      def base_dir_name(id=nil)
        @data_path_test ||= File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'data_for_test', 'IipData', ("00" + id.to_s)[-3..-1]))
      end
      
    end
    
  end
end