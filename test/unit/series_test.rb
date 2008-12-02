require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class SeriesTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_parts
      card1 = make_card('test_parts')
      card2 = make_card('test_parts2')
      series = make_series('test_parts')
      card1.series = series
      card2.series = series
      card1.save!
      card2.save!
      assert_equal([card1, card2], series.parts)
    end
    
    private
    
    def make_series(name)
      make_card(name, true, Series)
    end
    
  end
end