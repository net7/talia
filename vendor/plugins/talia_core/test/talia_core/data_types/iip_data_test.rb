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
        assert(File.exists?(File.join(dir_for_test, @test_records[14].id.to_s) + '_256x256'), "#{File.join(dir_for_test, @test_records[14].id.to_s) + '_256x256'} does not exist" )
      end
          
      private
      def base_dir_name(id=nil)
        @data_path_test ||= File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'data_for_test', 'IipData', ("00" + id.to_s)[-3..-1]))
      end
      
    end
    
  end
end