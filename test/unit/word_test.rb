require File.dirname(__FILE__) + '/../test_helper'

class WordTest < ActiveSupport::TestCase
  
  
  def test_add_word

    # add first word
    Word.add_word('word')
    word_record = Word.find(:first, :conditions => {:word => 'word'})

    assert_not_nil(word_record)
    assert_equal(word_record.counter, 1)

    # add a duplicated word
    Word.add_word('word')
    word_record = Word.find(:first, :conditions => {:word => 'word'})

    assert_not_nil(word_record)
    assert_equal(word_record.counter, 2)

  end

  def test_add_contribution

    # check raise for nil uri
    assert_raise(RuntimeError) {Word.add_contribution(nil)}

    # check raise for not found contribution
    assert_raise(ActiveRecord::RecordNotFound) {Word.add_contribution("not valid contribution")}

  end

end
