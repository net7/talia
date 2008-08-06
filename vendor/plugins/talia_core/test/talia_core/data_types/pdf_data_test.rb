require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

module TaliaCore
  module DataType
    
    # Test te DataRecord storage class
    class PdfDataTest < Test::Unit::TestCase
    
      fixtures :active_sources, :data_records
  
      def setup
        # Sets the file that is used by one test
        @test_records = DataTypes::DataRecord.find_data_records(Fixtures.identify(:something))
      end
      
      # test not nil and records numbers
      def test_records_numbers
        assert_not_equal [], @test_records
        assert_equal 14, @test_records.size
      end
      
      # test class type and mime_type and subtype
      def test_mime_types
        assert_kind_of DataTypes::PdfData, @test_records[13]
        assert_equal 'application/pdf', @test_records[13].mime_type
      end
      
      # test data directory
      def test_data_directory
        dir_for_test  = File.expand_path(@test_records[13].data_directory)
        assert_equal(base_dir_name(@test_records[13].id), dir_for_test)
        assert(File.exists?(dir_for_test))
        assert_equal(File.join(base_dir_name(@test_records[13].id), 'temp1.pdf'), File.join(dir_for_test, @test_records[13].location))
        assert( File.exists?(File.join(dir_for_test, @test_records[13].id.to_s)), "#{File.join(dir_for_test, @test_records[13].id.to_s)} does not exist" )
      end
      
      # test file size
      def test_file_size
        assert_equal(104463, @test_records[13].size)
      end
      
      # test binary access
      def test_binary_access
        # Check initial position
        assert_equal(0, @test_records[13].position)
      
        # Try to read all bytes
        bytes = @test_records[13].all_bytes
        assert_equal(104463, bytes.size)
        assert_equal(false, @test_records[13].is_file_open?)

      
        # Re-check position (it should be 0)
        assert_equal(0, @test_records[13].position)
      end
    
      private
      def base_dir_name(id=nil)
        @data_path_test ||= File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'data_for_test', 'PdfData', ("00" + id.to_s)[-3..-1]))
      end
    
    end
    
  end
end
