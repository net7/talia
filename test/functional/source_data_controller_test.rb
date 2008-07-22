require File.dirname(__FILE__) + '/../test_helper'

# Put a dummy data class here, just for this test
class TaliaCore::DummyDataRecord < TaliaCore::DataTypes::DataRecord
  def all_bytes
    "test string".unpack('C*')
  end

  def mime_type
    'dummy/dummy'
  end
  
  def type
    self.class.name.demodulize
  end
end

class SourceDataControllerTest < Test::Unit::TestCase
  include TaliaCore::DataTypes
  fixtures :active_sources, :data_records 
  
  # Setup some dome data, not quite nice but will do for now
  def setup
    @controller = SourceDataController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @source_name     = 'something'
    @unexistent_name = 'somewhat'
  end
  
  uses_mocha 'DataRecordTest' do
    # Test for existing data
    def test_show_data
      DataRecord.any_instance.stubs(:content_string).returns 'content_string'
      DataRecord.any_instance.stubs(:mime_type).returns Mime::TEXT
      get :show, { :type => 'DataRecord', :location => 'testlocation' }
      assert_response :success
    end
  end
  
  # Test against missing data
  def test_missing_data
    get :show, { :type => 'DataRecord', :location => 'foo' }
    assert_response :missing
  end
  
  def test_should_create
    rails_logo = uploaded_png fixture_path
    post :create, :data_record => { :file => rails_logo, :source_id => source_id }
    assert_response :success
    assert File.exists?(full_filename)
  end
  
  private
  # get us an object that represents an uploaded file
  def uploaded_file(path, content_type="application/octet-stream", filename=nil)
    filename ||= File.basename(path)
    t = Tempfile.new(filename)
    FileUtils.copy_file(path, t.path)
    (class << t; self; end;).class_eval do
      alias local_path path
      define_method(:original_filename) { filename }
      define_method(:content_type) { content_type }
    end
    t
  end

  # PNG helper
  def uploaded_png(path, filename=nil)
    uploaded_file(path, 'image/png', filename)
  end
  
  def source_id
    TaliaCore::Source.find(:first).id
  end
  
  def file
    'rails.png'
  end
  
  def fixture_path
    File.join(File.expand_path(RAILS_ROOT), 'test', 'fixtures', file)
  end
  
  def full_filename
    File.join(TaliaCore::DataTypes::DataRecord.data_path, 'ImageData', file)
  end
end
