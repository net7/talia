require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class FacsimileEditionTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_can_create
      create_edition
      assert_not_nil(@fe)
    end
    
    
    protected
    
    def create_edition
      @fe = FacsimileEdition.new('http://www.facsimile.org/edition')
    end
    
  end
end
