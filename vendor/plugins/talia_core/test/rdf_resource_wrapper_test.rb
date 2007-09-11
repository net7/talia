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
    
    # One-time setup
    @@rdf_resource = RdfResourceWrapper.new("http://foo/")
    (1..10).each do |num|
      resource = RdfResourceWrapper.new("http://foo/xy#{num}")
      resource.foo::exists = "true"
      resource.foo::someone = @@rdf_resource
      resource.save
    end
    (1..10).each do |num|
      resource = RdfResourceWrapper.new("http://foo/zz#{num}")
      resource.foo::exists = "false"
      resource.foo::somebody = @@rdf_resource
      resource.save
    end
    
    def setup
      TestHelper.fixtures # Just to clean the db
    end
    
    # Test the getter and setter
    def test_getter_setter
      @@rdf_resource["http://author/"] << "bar"
      assert_kind_of(SourcePropertyList, @@rdf_resource["http://author/"])
      assert_equal(1, @@rdf_resource["http://author/"].size)
      assert_equal("bar", @@rdf_resource["http://author/"][0])
    end
    
    # Test the getter and setter with a source
    def test_getter_setter_source
      source = Source.new("http://xxxx/")
      @@rdf_resource["http://author2/"] << source
      assert_equal(source.uri, @@rdf_resource["http://author2/"][0].uri)
    end
    
    # Test the direct_predicates accessor
    def test_direct_predicates
      @@rdf_resource["http://dpred/"] << "bar"
      assert_equal(1, @@rdf_resource.direct_predicates.size)
      assert_kind_of(N::Predicate, @@rdf_resource.direct_predicates[0])
      assert_equal("http://dpred/", @@rdf_resource.direct_predicates[0].to_s)
    end
    
    # Test if the find with hash works
    def test_find_from_hash_all
      assert_equal(21, RdfResourceWrapper.find_from_hash.size)
    end
    
    # Test if the find with hash works
    def test_find_from_hash_simple
      assert_equal(10, RdfResourceWrapper.find_from_hash(N::FOO::exists => "true").size)
      assert_equal(10, RdfResourceWrapper.find_from_hash(N::FOO::exists => "false").size)
      assert_equal(0, RdfResourceWrapper.find_from_hash(N::FOO::exists => "xxx").size)
    end
    
    # Test if find from hash works with other resources as elements
    def test_find_from_hash_resources
      assert_equal(10, RdfResourceWrapper.find_from_hash(N::FOO::someone => @@rdf_resource).size)
      assert_equal(10, RdfResourceWrapper.find_from_hash(N::FOO::somebody => @@rdf_resource).size)
      assert_equal(0, RdfResourceWrapper.find_from_hash(N::FOO::somewhat => @@rdf_resource).size)
    end
    
    # Test the LIMIT check
    def test_find_from_hash_limit
      assert_equal(5, RdfResourceWrapper.find_from_hash(N::FOO::exists => "true", :limit => 5).size)
    end
 
    
    # Test type accessor
    def test_set_get_types
      @@rdf_resource.types << N::SourceClass.new("http://type1/")
      @@rdf_resource.types << N::SourceClass.new("http://type2/")
      assert_equal(2, @@rdf_resource.types.size)
      assert_not_nil(@@rdf_resource.types.find { |type| type.to_s == "http://type1/" })
    end
    
    # Test find with types
    def test_find_types
      check_res = RdfResourceWrapper.new("http://findwithtypes/")
      check_res.types << N::SourceClass.new("http://findme/")
      result = RdfResourceWrapper.find_from_hash(:type => "http://findme/")
      assert_equal(1, result.size)
      assert_equal(check_res.uri, result[0].uri.to_s)
    end

  end
end