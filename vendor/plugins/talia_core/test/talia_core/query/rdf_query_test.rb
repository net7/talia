require 'test/unit'

# Load the helper 
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

module TaliaCore
  
  # Test the RdfQuery class
  class RdfQueryTest < Test::Unit::TestCase
    
    TestHelper::startup
    
    def setup
      setup_once(:flush) do
        TestHelper::flush_rdf()
        TestHelper::flush_db()
      end
      setup_once(:s1) do
        s1 = Source.new("http://foo_one")
        s1.workflow_state = 0
        s1.primary_source = true
        s1.save!
        s1.foo::workstate << "0"
        s1.foo::primary << "true"
        s1.save!
        s1
      end
      setup_once(:s2) do
        s2 = Source.new("http://foo_two", N::FOO::eatthis, N::FOO::hello)
        s2.workflow_state = 1
        s2.primary_source = false
        s2.save!
        s2.foo::type << "eatthis"
        s2.foo::type << "hello"
        s2.foo::workstate << "1"
        s2.foo::primary << "false"
        s2.save!
        s2
      end
      setup_once(:s3) do
        s3 = Source.new("http://foo_three", N::FOO::barme, N::FOO::hello)
        s3.workflow_state = 1
        s3.primary_source = true
        s3.save!
        s3.foo::type << "barme"
        s3.foo::type << "hello"
        s3.foo::workstate << "1"
        s3.foo::primary << "true"
        s3.foo::friend << @s2
        s3.save!
        s3
      end
    end
    
    # Find on simple expression
    def test_find_expression
      qry = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "1")
      result = qry.execute
      assert_equal(2, result.size)
    end
    
    # Find on simple expression, with just a single result
    def test_find_expression_single
      qry = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "0")
      result = qry.execute
      assert_equal(1, result.size)
      assert_kind_of(Source, result[0])
      assert_equal("http://foo_one", result[0].uri.to_s)
    end
    
    # Find on simple expression that is a relation
    def test_find_by_resource_relation
      qry = RdfQuery.new(:EXPRESSION, N::FOO::friend, Source.new("http://foo_two"))
      result = qry.execute
      assert_equal(1, result.size)
      assert_kind_of(Source, result[0])
      assert_equal("http://foo_three", result[0].uri.to_s)
    end
    
    # Find on simple expression that is a relation if an URI is given 
    # (If an URI object is given, it's clear that a resource is meant)
    def test_find_by_resource_relation_by_uri
      qry = RdfQuery.new(:EXPRESSION, N::FOO::friend, N::URI.new("http://foo_two"))
      result = qry.execute
      assert_equal(1, result.size)
      assert_kind_of(Source, result[0])
      assert_equal("http://foo_three", result[0].uri.to_s)
    end
    
    # Find on workflow state, without result
    def test_find_expression_nothing  
      qry = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "4")
      result = qry.execute
      assert_equal(0, result.size)
    end
    
    # Try an AND query
    def test_and_query
      qry1 = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "1")
      qry2 = RdfQuery.new(:EXPRESSION, N::FOO::primary, "false")
      qry = RdfQuery.new(:AND, qry1, qry2)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_two", result[0].uri.to_s)
    end
    
    # Try an OR query
    def test_or_query
      qry1 = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "1")
      qry2 = RdfQuery.new(:EXPRESSION, N::FOO::primary, "false")
      qry = RdfQuery.new(:OR, qry1, qry2)
      result = qry.execute
      assert_equal(2, result.size)
    end
    
    # Test a query with multiple options
    def test_multi_and
      qry1 = RdfQuery.new(:EXPRESSION, N::FOO::type, "hello")
      qry2 = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "1")
      qry3 = RdfQuery.new(:EXPRESSION, N::FOO::primary, "true")
      qry = RdfQuery.new(:AND, qry1, qry2, qry3)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_three", result[0].uri.to_s)
    end
    
    # Test a query with multiple options
    def test_multi_or
      qry1 = RdfQuery.new(:EXPRESSION, N::FOO::type, "hello")
      qry2 = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "1")
      qry3 = RdfQuery.new(:EXPRESSION, N::FOO::primary, "true")
      qry = RdfQuery.new(:OR, qry1, qry2, qry3)
      result = qry.execute
      assert_equal(3, result.size)
    end
    
    # Test query with nested options. This also tests the and and or
    # methods
    def test_nested
      qry = RdfQuery.new(:EXPRESSION, N::FOO::type, "barme")
      qry = qry.and(RdfQuery.new(:EXPRESSION, N::FOO::type, "hello"))
      qry = qry.or(RdfQuery.new(:EXPRESSION, N::FOO::primary, "true"))
      result = qry.execute
      assert_equal(2, result.size)
    end
    
    # Tests if the query still returns the correct results when executed twice
    def test_execute_twice
      qry = RdfQuery.new(:EXPRESSION, N::FOO::type, "barme")
      qry = qry.and(RdfQuery.new(:EXPRESSION, N::FOO::type, "hello"))
      qry = qry.or(RdfQuery.new(:EXPRESSION, N::FOO::primary, "true"))
      qry.execute
      qry.execute
      result = qry.execute
      assert_equal(2, result.size)
    end
    
    # Tests the limit and offset operators
    def test_offset_limit
      qry = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "1")
      qry.limit = 1
      result = qry.execute
      assert_equal(1, result.size)
      uri = result[0].uri.to_s
      assert((uri == "http://foo_three") || (uri == "http://foo_two"))
      # Now we test if we can get the other result with the offset
      qry.offset = 1
      result = qry.execute
      assert_equal(1, result.size)
      uri2 = result[0].uri.to_s
      assert((uri2 == "http://foo_three") || (uri2 == "http://foo_two"))
      assert_not_equal(uri, uri2)
    end
    
    # Test if an offset of zero works correctly
    def test_offset_zero
      qry = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "1")
      qry.limit = 1
      result = qry.execute
      qry2 = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "1")
      qry2.limit = 1
      qry2.offset = 0
      result2 = qry2.execute
      assert_equal(result[0].uri, result2[0].uri)
    end
    
    # Tests adding an and operation with database (force_rdf off)
    def test_db_and_no_force
      qry = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "1")
      qry = qry.and(DbQuery.new(:EXPRESSION, :primary_source, true))
      assert_kind_of(MixedQuery, qry)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_three", result[0].uri.to_s)
    end
    
    # Tests adding an and operation with database (force_rdf on)
    def test_db_and_force
      qry = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "1")
      qry.force_rdf = true
      qry = qry.and(DbQuery.new(:EXPRESSION, :primary_source, true))
      assert_kind_of(RdfQuery, qry)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_three", result[0].uri.to_s)
    end
    
    # Tests adding an or operation with database (force_rdf off)
    def test_db_or_no_force
      qry = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "1")
      qry = qry.or(DbQuery.new(:EXPRESSION, :primary_source, true))
      assert_kind_of(MixedQuery, qry)
      result = qry.execute
      assert_equal(3, result.size)
    end
    
    # Tests adding an or operation with database (force_rdf on)
    def test_db_or_force
      qry = RdfQuery.new(:EXPRESSION, N::FOO::workstate, "1")
      qry.force_rdf = true
      qry = qry.or(DbQuery.new(:EXPRESSION, :primary_source, true))
      assert_kind_of(RdfQuery, qry)
      result = qry.execute
      assert_equal(3, result.size)
    end
    
  end
end
    