require File.dirname(__FILE__) + '/../../test_helper'

class StringTest < Test::Unit::TestCase
  def test_titleized
    assert_equal('Homer_Simpson'.titleize,
      'Homer_Simpson'.titleized)
  end
  
  def test_uri
    assert_equal('Homer_Simpson',
      'Homer Simpson'.uri)
  end
  
  def test_exists
    assert 'string'.exists?
  end
end
