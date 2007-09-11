require 'test/unit'
require File.dirname(__FILE__) + "/../lib/talia_core"

# Load the helper class
require File.dirname(__FILE__) + '/test_helper'

module TaliaCore
  
  # Test the RdfPropertyListWrapper class
  class SourcePropertyListTest < Test::Unit::TestCase
    
    # Establish the database connection for the test
    TestHelper.startup
    Namespace.register(:foo, "http://newfoo.com/xxx#")
    
    def setup
      @rdf_resource = RdfResourceWrapper.new("http://foo/")
      (1..10).each do |num|
        resource = RdfResourceWrapper.new("http://foo/xy#{num}")
        @rdf_resource[N::FOO::test] << resource
      end
      @prop_list = @rdf_resource[N::FOO::test]
    end
    
    # Test the basics
    def test_predicate_list_basic
      assert_kind_of(SourcePropertyList, @prop_list)
      assert_equal(10, @prop_list.size)
    end
    
    # Test getting an empty list
    def test_get_empty_list
      list = @rdf_resource[N::FOO::nuffink]
      assert_equal(0, list.size)
    end
    
    # Test the add functionality
    def test_add_to_predicate_list
      list = @rdf_resource[N::FOO::adding]
      list << "foo"
      assert_equal(1, list.size)
      list << "bar"
      assert_equal(2, list.size)
    end
    
    # Test the assignment operator
    def test_assign_in_predicate_list
      @rdf_resource[N::FOO::assigning] << "bar"
      list = @rdf_resource[N::FOO::assigning]
      assert_equal("bar", list[0])
      list["bar"] = "foo"
      assert_equal("foo", list[0])
    end
    
    # Test the assignment operator with Sources
    def test_assign_in_predicate_list
      source = Source.new("http://somesource/me")
      @rdf_resource[N::FOO::assigning] << source
      list = @rdf_resource[N::FOO::assigning]
      assert_kind_of(Source, list[0])
      assert_equal("http://somesource/me", list[0].uri.to_s)
      newsource = Source.new("http://somesource/new")
      list[source] = newsource
      assert_equal("http://somesource/new", list[0].uri.to_s)
    end
    
    # Test the removal from a property liste
    def test_remove_from_property_list
      list = @rdf_resource[N::FOO::removing]
      list << "one"
      list << "two"
      list << "three"
      
      assert_equal(3, list.size)
      list.remove("one")
      assert_equal(2, list.size)
      list.remove
      assert_equal(0, list.size)
    end
    
    # Test removal with Sources
    def test_remove_from_property_list
      list = @rdf_resource[N::FOO::removing]
      list << Source.new("http://remove/one")
      list << Source.new("http://remove/two")
      
      assert_equal(2, list.size)
      list.remove(Source.new("http://remove/one"))
      assert_equal(1, list.size)
      assert_equal("http://remove/two", list[0].uri.to_s)
    end
    
    # Test equality comparison self
    def test_equal_self
      assert_equal(@prop_list, @prop_list)
    end
    
    # Test comparison
    def test_equal
      list1 = @rdf_resource[N::FOO::comparable]
      list2 = @rdf_resource[N::FOO::comparable]
      list1 << "foo"
      list2 << "foo"
      assert_equal(list1, list2)
    end
    
    # Test equality operator for unequal things
    def test_unequal
      list1 = @rdf_resource[N::FOO::comparable]
      list2 = @rdf_resource[N::FOO::comparable]
      list1 << "foo"
      list2 << "bar"
      assert_not_equal(list1, list2)
    end
  end
end