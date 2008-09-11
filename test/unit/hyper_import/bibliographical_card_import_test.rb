require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class AutorImportTest < Test::Unit::TestCase
  
    include UtilTestMethods
    
    suppress_fixtures
    
    # Test if the dummy export doesn't crash
    def test_dummy_import
      assert_nil(hyper_import(load_doc('chenkeszinigerike-930')))
    end
    
  end
end