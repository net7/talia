require 'test/unit'
require File.dirname(__FILE__) + "/../lib/talia_core"

# Load the helper class
require File.dirname(__FILE__) + '/test_helper'

module TaliaCore
  
  # Test the SourceType class
  class RdfResourceWrapperTest < Test::Unit::TestCase
 
    # Establish the database connection for the test
    TestHelper.startup
    
    def setup
      @rdf_resource = RdfResourceWrapper.new("http://foo/")
    end
    
    # Test the getter and setter
    def test_getter_setter
      @rdf_resource["http://author/"] = "bar"
      assert_equal("bar", @rdf_resource["http://author/"])
    end
    
    # Test the getter and setter with a source
     def test_getter_setter_source
       source = Source.new("http://xxxx/")
       @rdf_resource["http://author2/"] = source
       assert_equal(source.uri, @rdf_resource["http://author2/"].uri)
       assert_kind_of(Source, source)
     end
    
  end
end