require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), 'test_helper')

module TaliaCore

  # Test te DataRecord storage class
  class XmlDataTest < Test::Unit::TestCase
  
    # Establish the database connection for the test
    TestHelper.startup
     
    def setup
      TestHelper.fixtures
      @test_records = DataRecord.find_data_records(1)
    end
    
    # test not nil and records numbers
    def test_records_numbers
      assert_not_equal [], @test_records
      assert_equal 11, @test_records.size
    end
  
    # test class type and mime_type and subtype
    def test_mime_types
      assert_kind_of(XmlData, @test_records[2])
      assert_kind_of(XmlData, @test_records[3])
      assert_kind_of(XmlData, @test_records[4])
      assert_equal("text/xml", @test_records[2].mime_type)
      assert_equal("xml", @test_records[2].mime_subtype)
      assert_equal("text/html", @test_records[3].mime_type)
      assert_equal("html", @test_records[3].mime_subtype)
      assert_equal("text/hnml", @test_records[4].mime_type)
      assert_equal("hnml", @test_records[4].mime_subtype)
    end
    
    # test data directory
    def test_data_directory
      base_dir_name = File.expand_path(File.join(File.dirname(__FILE__), 'data_for_test', 'XmlData'))
      dir_for_test  = File.expand_path(@test_records[2].data_directory)
      assert_equal(base_dir_name, dir_for_test)
      assert(File.exists?(dir_for_test))
      assert_equal(File.join(base_dir_name, 'temp1.xml'), File.join(dir_for_test, @test_records[2].location))
      assert( File.exists?(File.join(dir_for_test, @test_records[2].location)), "#{File.join(dir_for_test, @test_records[2].location)} does not exist" )
    end

    # test file size
    def test_file_size
      assert_equal(300, @test_records[2].size)
    end
    
    # test binary access
    def test_binary_access
      # Check initial position
      assert_equal(0, @test_records[2].position)
      
      # Try to read all bytes
      bytes = @test_records[2].all_bytes
      assert_equal(300, bytes.size)
      assert_equal(false, @test_records[2].is_file_open?)

      
      # Re-check position (it should be 0)
      assert_equal(0, @test_records[2].position)
      
      # Read only one bytes and check position
      byte = @test_records[2].get_byte
      # check byte by code (60 == '<')
      assert_equal(60, byte)
      # Re-check position (it should be 1)
      assert_equal(1, @test_records[2].position)
    end
    
    # test for specific classes methods
    def test_specific_classes_methods
      # test content value
      xml_content =  @test_records[2].get_content
      html_content = @test_records[3].get_content
      hnml_content = @test_records[4].get_content
      
      assert_kind_of REXML::Elements, xml_content
      assert_not_equal nil, xml_content.nil?
      
      assert_kind_of REXML::Elements, html_content
      assert_not_equal nil, html_content.nil?
      
      assert_kind_of REXML::Elements, hnml_content
      assert_not_equal nil, hnml_content.nil?
    end
  end
   
end

