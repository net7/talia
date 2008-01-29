require File.dirname(__FILE__) + '/../test_helper'
require 'pagination/source_paginator'

include TaliaCore

# Test the application helpers
class SourcePaginatorTest < Test::Unit::TestCase
  
  # Checks if the paginator actually contains objects. This is for an "all"
  # paginator
  def test_paginate_all_count
    pager = SourcePaginator.new(TaliaCore::SourceRecord.count, 5)
    assert(pager.count > 0)
    assert_equal(TaliaCore::SourceRecord.count, pager.count)
    assert_equal(5, pager.per_page)
  end
  
  # Test creation of a page
  def test_get_page
    pager = SourcePaginator.new(TaliaCore::SourceRecord.count, 5)
    page = pager.page(1)
    assert_not_nil(page)
    expected_size = TaliaCore::SourceRecord.count > 5 ?  5 : TaliaCore::SourceRecord.count
    assert_equal(expected_size, page.items.size)
  end
end