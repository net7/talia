require File.dirname(__FILE__) + '/../test_helper'

# Put a dummy data class here, just for this test
class TaliaCore::DummyDataRecord < TaliaCore::DataRecord
  def all_bytes
    "test string".unpack('C*')
  end

  def mime_type
    'dummy/dummy'
  end
end

class SourceDataControllerTest < Test::Unit::TestCase

  fixtures :source_records, :data_records 
  
  # Setup some dome data, not quite nice but will do for now
  def setup
    @controller = SourceDataController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @source_name      = 'something'
    @unexistent_name  = 'somewhat'
  end
  
  # Test for existing data
  def test_show_data
    get :show, { :type => 'dummy_data_record', :location => 'testlocation' }
    assert_response :success
  end
  
  # Test against missing data
  def test_missing_data
    get :show, { :type => 'dummy_data_record', :location => 'foo' }
    assert_response :missing
  end
  
end
