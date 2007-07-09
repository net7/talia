require File.dirname(__FILE__) + '/../test_helper'

include TaliaCore

# Test the application helpers
class SourceUsageTest < Test::Unit::TestCase
  
  fixtures :source_records, :srecord_types, :srecord_dirty_relations
  
  def test_store_classes
   record = TaliaCore::SourceRecord.find(1)
   assert_equal(2, record.types.count)
  end
  
end