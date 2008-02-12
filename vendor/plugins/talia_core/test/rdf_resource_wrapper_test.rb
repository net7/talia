require 'test/unit'
require File.dirname(__FILE__) + "/../lib/talia_core"

# Load the helper class
require File.dirname(__FILE__) + '/test_helper'

module TaliaCore
  
  # Test the SourceType class
  class RdfResourceWrapperTest < Test::Unit::TestCase
 
    # Establish the database connection for the test
    TestHelper.startup
    Namespace.register(:foo, N::FOO.to_s)
    
    def setup
      setup_once(:flush) do
        TestHelper.flush_db # Just to clean the db
        TestHelper.flush_rdf # Just to clean the db
      end
      setup_once(:rdf_resource) do
        TestHelper.make_dummy_source("http://foo/")    
        RdfResourceWrapper.new("http://foo/")
      end
      setup_once(:resources) do
        (1..10).each do |num|
          resource = RdfResourceWrapper.new("http://foo/xy#{num}")
          resource.foo::exists = "true"
          resource.foo::someone = @rdf_resource
          resource.save
        end
        (1..10).each do |num|
          resource = RdfResourceWrapper.new("http://foo/zz#{num}")
          resource.foo::exists = "false"
          resource.foo::somebody = @rdf_resource
          resource.save
        end
      end
    end
    
    # Test the getter and setter
    def test_getter_setter
      @rdf_resource["http://author/"] << "bar"
      assert_kind_of(SourcePropertyList, @rdf_resource["http://author/"])
      assert_equal(1, @rdf_resource["http://author/"].size)
      assert_equal("bar", @rdf_resource["http://author/"][0])
    end
    
    # Test the getter and setter with a source
    def test_getter_setter_source
      source = Source.new("http://xxxx/")
      @rdf_resource["http://author2/"] << source
      assert_equal(source.uri, @rdf_resource["http://author2/"][0].uri)
    end
    
    # Test the direct_predicates accessor
    def test_direct_predicates
      @rdf_resource["http://dpred/"] << "bar"
      # Expected size one for each database dupe, plus one for the
      # RDF type, plus one for the attribute we added above
      expected_size = SourceRecord.content_columns.size + 2 
      assert_equal(expected_size, @rdf_resource.direct_predicates.size)
      assert_kind_of(N::Predicate, @rdf_resource.direct_predicates[0])
      assert_equal("http://dpred/", @rdf_resource.direct_predicates[0].to_s)
    end

  end
end