require File.dirname(__FILE__) + '/../test_helper'

# Test the application helpers
class SourceUsageTest < Test::Unit::TestCase
  
  fixtures :source_records
  
  def test_dummy
    uri = TaliaCore::URI.new("test")
    record = TaliaCore::SourceRecord.new
    sassert(false)
  end
  
end