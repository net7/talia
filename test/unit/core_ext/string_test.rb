require File.dirname(__FILE__) + '/../../test_helper'

class StringTest < Test::Unit::TestCase
  def test_to_permalink
    assert_equal('Should_Strip_All_Non_Word_Chars', 'should strip *all* non-word chars!'.to_permalink)
    assert_equal('Should_Strip_White_Spaces', 'should strip    white    spaces'.to_permalink)
    assert_equal('Should_Titleize_Mixed_Case_Strings', 'sHoULD tItLEIzE mIxEd cAsE sTrINgS'.to_permalink)
    assert_equal('Should_Replace_Spaces_With_Underscores', 'should replace spaces with underscores'.to_permalink)
  end
end
