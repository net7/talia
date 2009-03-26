require 'test/unit'
require 'fileutils'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class UploadedFile < File
  include ActionController::UploadedFile
  attr_accessor_with_default(:content_type) { 'text/plain' }
  alias_method :original_path, :path
  
  def size
    self.class.size(original_path)
  end
end

module TaliaCore

  # Test the DataRecord storage class
  class FileRecordTest < Test::Unit::TestCase
  
    fixtures :active_sources, :data_records
    
    def setup
      @test_records = DataTypes::DataRecord.find_data_records(Fixtures.identify(:something))
    end
    
    def test_create_from_data
      create_from do |record|
        record.create_from_data('loc', 'abc')
      end
    end
    
    def test_create_from_file_and_delete
      from_file = File.join(File.dirname(__FILE__), '..', '..', 'data_for_test', 'test_source_file')
      tmp_file = File.join(File.dirname(__FILE__), '..', '..', 'data_for_test', 'test_source_file_copy')
      FileUtils.copy(from_file, tmp_file)
      assert(File.exist?(tmp_file))
      create_from do |record|
        record.create_from_file('loc', tmp_file, true)
      end
      assert(!File.exist?(tmp_file))
    end
    
    def test_create_from_file
      create_from do |record|
        from_file = File.join(File.dirname(__FILE__), '..', '..', 'data_for_test', 'test_source_file')
        record.create_from_file('loc', from_file)
      end
    end

    def test_extract_filename
      assert_equal('1', DataTypes::FileRecord.extract_filename(file))
    end
    
    def test_file_should_always_return_nil
      assert_nil(DataTypes::FileRecord.new.file)
    end
    
    def test_full_filename
      data_record = DataTypes::FileRecord.new do |dr|
        dr.source_id = 1
        dr.location  = 'image.jpg'
        dr.assign_type 'image/jpeg'
      end
      data_record.save
      expected = File.expand_path(File.join(File.dirname(__FILE__), '..','..', 'data_for_test', 'FileRecord', ("00" + data_record.id.to_s)[-3..-1], data_record.id.to_s)) #File.join(DataTypes::DataRecord.data_path, data_record.type, data_record.location)
      assert_equal(expected, data_record.send(:full_filename))
    end
    
        
    def test_paths
      tempfile_path = File.join(TALIA_ROOT, 'tmp', 'data_records')
      data_path     = File.join(TALIA_ROOT, 'data')
      assert_equal(tempfile_path, DataTypes::FileRecord.tempfile_path)
      assert_equal(tempfile_path, DataTypes::FileRecord.new.send(:tempfile_path))
      assert_equal(data_path, DataTypes::FileRecord.data_path)
      assert_equal(data_path, DataTypes::FileRecord.new.send(:data_path))
    end
    
    # test binary access
    def test_binary_access
      # Check initial position
      assert_equal(0, @test_records[0].position)
      
      # Try to read all bytes
      bytes = @test_records[0].all_bytes
      assert_equal(180, bytes.size)
      assert_equal(false, @test_records[0].is_file_open?)

      # Re-check position (it should be 0)
      assert_equal(0, @test_records[0].position)
      
      # Read only one bytes and check position
      byte = @test_records[0].get_byte
      # check byte by code (76 == 'L')
      assert_equal(76, byte)
      # Re-check position (it should be 1)
      assert_equal(1, @test_records[0].position)
    end
    
    # test data directory
    def test_data_directory
      dir_for_test = File.expand_path(@test_records[0].data_directory)
      assert_equal(data_path_test(@test_records[0].id), dir_for_test)
      assert( File.exists?(dir_for_test) )
      assert_equal('temp1.txt', @test_records[0].location)
      assert( File.exists?(File.join(data_path_test(@test_records[0]),@test_records[0].id.to_s)), "#{File.join(data_path_test(@test_records[0]), @test_records[0].id.to_s)} does not exist" )
    end

    def test_should_find_or_create_and_assign_file
      # FIXME: I use #file and #source_id instead of fixtures,
      # due to unpredictable ids assignment.
      # Because test process doesn't drop tables, but just empty and re-fill them.
      params = {:file => file, :source_id => source_id}
      assert(DataTypes::FileRecord.find_or_create_and_assign_file(params))
    end

    # test file size
    def test_file_size
      assert_equal(180, @test_records[0].size)
    end
    
        
    def test_should_save_attachment
      assert(!DataTypes::FileRecord.new.send(:save_attachment?))
      data_record = DataTypes::FileRecord.new do |dr|
        dr.file = file
      end
      assert(data_record.send(:save_attachment?))
    end
    
    private
    def data_path_test(id=nil)
      @data_path_test ||= File.expand_path(File.join(File.dirname(__FILE__), '..','..', 'data_for_test', 'SimpleText', ("00" + id.to_s)[-3..-1]))
    end

    def file
      UploadedFile.new(File.join(data_path_test(DataTypes::DataRecord.find(:first).id), DataTypes::DataRecord.find(:first).id.to_s))
    end
    
    
    def source_id
      Source.find(:first)[:id]
    end

    def create_from(expected_content = 'abc')
      data_record = DataTypes::FileRecord.new
      yield(data_record)
      data_record.source = TaliaCore::Source.find(:first)
      data_record.save!
      new_rec = DataTypes::DataRecord.find(data_record.id)
      assert_equal(expected_content, new_rec.content_string)
    end
    
  end
end
