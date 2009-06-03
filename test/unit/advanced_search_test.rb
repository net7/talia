require File.dirname(__FILE__) + '/../test_helper'

class AdvancedSearchTest < ActiveSupport::TestCase
  
  def setup
    setup_once(:init) do
      TaliaUtil::Util.flush_rdf
      TaliaUtil::Util.flush_db
      true
    end
  end

end
