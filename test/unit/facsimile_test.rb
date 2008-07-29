require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class FacsimileTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_true
      assert(true)
    end
    
  end
end

