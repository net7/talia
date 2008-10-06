# Load the helper class
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

module TaliaCore
  # Test the DataRecord storage class
  class DataRecordTest < Test::Unit::TestCase
    
    fixtures :active_sources, :data_records

    def setup
      @test_records = DataTypes::DataRecord.find_data_records(Fixtures.identify(:something))
      
      setup_once(:image_mime_types) do
        Mime::Type.register "image/gif", :gif, [], %w( gif )
        Mime::Type.register "image/jpeg", :jpeg, [], %w( jpeg jpg jpe jfif pjpeg pjp )
        Mime::Type.register "image/png", :png, [], %w( png )
        Mime::Type.register "image/tiff", :tiff, [], %w( tiff tif )
        Mime::Type.register "image/bmp", :bmp, [], %w( bmp )
        image_mime_types = ['image/gif', 'image/jpeg', 'image/png', 'image/tiff', 'image/bmp']
        image_mime_types
      end
    end
    
    # test not nil and records numbers
    def test_records_numbers
      assert_not_equal [], @test_records
      assert_equal 15, @test_records.size
    end
  
    # test class type and mime_type
    def test_mime_types
      assert_kind_of(DataTypes::SimpleText, @test_records[0])
      assert_kind_of(DataTypes::SimpleText, @test_records[1])
      assert_equal("text/plain", @test_records[0].mime_type)
      assert_equal("text/plain", @test_records[1].mime_type)
    end
    

    
    # test for specific classes methods
    def test_specific_classes_methods
      # Get a line
      line = "LINE1: This is a simple text to check the DataRecords class\n"
      assert_equal(line, @test_records[0].get_line)
    end
    
    def test_class_type_from
      ['text/plain'].each do |mime|
        assert_equal('SimpleText', DataTypes::DataRecord.class_type_from(mime))
      end

      @image_mime_types.each { |mime| assert_equal('ImageData', DataTypes::DataRecord.class_type_from(mime)) }
      
      ['text/xml', 'application/xml'].each do |mime|
        assert_equal('XmlData', DataTypes::DataRecord.class_type_from(mime))
      end
      
      assert_equal('DataRecord', DataTypes::DataRecord.class_type_from('application/rtf'))
    end

  end  
end
