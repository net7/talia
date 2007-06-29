require 'test/unit'
require File.dirname(__FILE__) + "/../lib/talia_core"

module TaliaCore
  
  # Test the SourceType class
  class TaliaCoreTest < Test::Unit::TestCase
  
    def test_source_type
      uri_s = "http://mything.com/type"
      uri_s2 = URI.new("http://mything.com/type2")
      SourceType.register(:Type_One, uri_s)
      SourceType.register(:Type_two, uri_s2)
      
      assert_raise(DuplicateIdentifierError) { SourceType.register(:Type_three, uri_s) }
      assert_raise(DuplicateIdentifierError) { SourceType.register(:Type_one, "http://newtype") }
      
      assert(SourceType.const_defined?(:Type_one))
      assert(!SourceType.const_defined?(:Type_One))
      assert(!SourceType.const_defined?(:Type_three))
      assert(!SourceType.const_defined?(:Type_four))
      
      assert_equal(uri_s2, SourceType::Type_two)
    end
  end
end