require 'test/unit'
require File.dirname(__FILE__) + "/../lib/talia_core"

# Load the helper 
require File.dirname(__FILE__) + '/test_helper'

module TaliaCore
  
  # Test the DbQuery class
  class DbQueryTest < Test::Unit::TestCase
    
    TestHelper::startup
    @@is_setup = false
    
    def db_setup
      # Setup the database things
      TestHelper::flush_db()
      s1 = Source.new("http://foo_one")
      s1.workflow_state = 0
      s1.primary_source = true
      s1.save!
      s2 = Source.new("http://foo_two", N::FOO::eatthis, N::FOO::hello)
      s2.workflow_state = 1
      s2.primary_source = false
      s2.save!
      s3 = Source.new("http://foo_three", N::FOO::barme, N::FOO::hello)
      s3.workflow_state = 1
      s3.primary_source = true
      s3.save!
    end
    
    def setup
      # We need to setup the database things only once
      db_setup if(!@@is_setup)
      @@is_setup = true
    end
    
    # Find on workflow state
    def test_find_wf_state
      qry = DbQuery.new(:EXPRESSION, :workflow_state, 1)
      result = qry.execute
      assert_equal(2, result.size)
    end
    
    # Find on workflow state again
    def test_find_wf_state_single
      qry = DbQuery.new(:EXPRESSION, :workflow_state, 0)
      result = qry.execute
      assert_equal(1, result.size)
      assert_kind_of(Source, result[0])
      assert_equal("http://foo_one", result[0].uri.to_s)
    end
    
    # Find on workflow state, without result
    def test_find_wf_state_nothing
      qry = DbQuery.new(:EXPRESSION, :workflow_state, 4)
      result = qry.execute
      assert_equal(0, result.size)
    end
    
    # Try an AND query
    def test_and_query
      qry1 = DbQuery.new(:EXPRESSION, :workflow_state, 1)
      qry2 = DbQuery.new(:EXPRESSION, :primary_source, false)
      qry = DbQuery.new(:AND, qry1, qry2)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_two", result[0].uri.to_s)
    end
    
    # Try an OR query
    def test_or_query
      qry1 = DbQuery.new(:EXPRESSION, :workflow_state, 1)
      qry2 = DbQuery.new(:EXPRESSION, :primary_source, false)
      qry = DbQuery.new(:OR, qry1, qry2)
      result = qry.execute
      assert_equal(2, result.size)
    end
    
    
    # Try a query for type information
    def test_type_query
      qry = DbQuery.new(:EXPRESSION, :type, N::FOO::eatthis)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_two", result[0].uri.to_s)
    end
    
    # Test if the type query works with AND 
    def test_type_query_and
      qry1 = DbQuery.new(:EXPRESSION, :type, N::FOO::eatthis)
      qry2 = DbQuery.new(:EXPRESSION, :type, N::FOO::hello)
      qry = DbQuery.new(:AND, qry1, qry2)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_two", result[0].uri.to_s)
    end
    
    # Test if the type query works with OR 
    def test_type_query_or
      qry1 = DbQuery.new(:EXPRESSION, :type, N::FOO::eatthis)
      qry2 = DbQuery.new(:EXPRESSION, :type, N::FOO::hello)
      qry = DbQuery.new(:OR, qry1, qry2)
      result = qry.execute
      assert_equal(2, result.size)
    end
    
    # Test if the type query and other options can be combined
    def test_type_and_wf_state_and
      qry1 = DbQuery.new(:EXPRESSION, :type, N::FOO::eatthis)
      qry2 = DbQuery.new(:EXPRESSION, :workflow_state, 1)
      qry = DbQuery.new(:AND, qry1, qry2)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_two", result[0].uri.to_s)
    end
    
    # Test if the type query and other options can be combined
    def test_type_and_wf_state_or
      qry1 = DbQuery.new(:EXPRESSION, :type, N::FOO::eatthis)
      qry2 = DbQuery.new(:EXPRESSION, :workflow_state, 1)
      qry = DbQuery.new(:OR, qry1, qry2)
      result = qry.execute
      assert_equal(2, result.size)
    end
    
    # Test a query with multiple options
    # Test if the type query and other options can be combined
    def test_multi_and
      qry1 = DbQuery.new(:EXPRESSION, :type, N::FOO::hello)
      qry2 = DbQuery.new(:EXPRESSION, :workflow_state, 1)
      qry3 = DbQuery.new(:EXPRESSION, :primary_source, true)
      qry = DbQuery.new(:AND, qry1, qry2, qry3)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_three", result[0].uri.to_s)
    end
    
    # Test a query with multiple options
    # Test if the type query and other options can be combined
    def test_multi_or
      qry1 = DbQuery.new(:EXPRESSION, :type, N::FOO::hello)
      qry2 = DbQuery.new(:EXPRESSION, :workflow_state, 1)
      qry3 = DbQuery.new(:EXPRESSION, :primary_source, true)
      qry = DbQuery.new(:OR, qry1, qry2, qry3)
      result = qry.execute
      assert_equal(3, result.size)
    end
    
    # Test query with nested options. This also tests the and and or
    # methods
    def test_nested
      qry = DbQuery.new(:EXPRESSION, :type, N::FOO::barme)
      qry = qry.or(DbQuery.new(:EXPRESSION, :primary_source, false))
      qry = qry.and(DbQuery.new(:EXPRESSION, :type, N::FOO::eatthis))
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_two", result[0].uri.to_s)
    end
    
    # Tests if the query still returns the correct results when executed twice
    def test_execute_twice
      qry = DbQuery.new(:EXPRESSION, :type, N::FOO::barme)
      qry = qry.or(DbQuery.new(:EXPRESSION, :primary_source, false))
      qry = qry.and(DbQuery.new(:EXPRESSION, :type, N::FOO::eatthis))
      qry.execute
      qry.execute
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_two", result[0].uri.to_s)
    end
    
    # Tests the limit and offset operators
    def test_offset_limit
      qry = DbQuery.new(:EXPRESSION, :workflow_state, 1)
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
    
    # Test the conversion to an RDF query
    def test_rdf_convert
      qry = DbQuery.new(:EXPRESSION, :type, N::FOO::barme)
      qry = qry.and(DbQuery.new(:EXPRESSION, :type, N::FOO::hello))
      qry = qry.or(DbQuery.new(:EXPRESSION, :primary_source, true))
      rdf_qry = qry.convert_rdf
      assert_kind_of(RdfQuery, rdf_qry)
      result = rdf_qry.execute
      assert_equal(2, result.size)
    end
    
    # Test the conversion to an RDF query with and
    def test_rdf_convert_and
      qry = DbQuery.new(:EXPRESSION, :type, N::FOO::barme)
      qry = qry.and(DbQuery.new(:EXPRESSION, :type, N::FOO::hello))
      rdf_qry = qry.convert_rdf
      assert_kind_of(RdfQuery, rdf_qry)
      result = rdf_qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_three", result[0].uri.to_s)
    end
    
    # Find on workflow state, using the RDF dupes
    def test_find_wf_state_on_rdf
      qry = DbQuery.new(:EXPRESSION, :workflow_state, 1).convert_rdf
      result = qry.execute
      assert_equal(2, result.size)
    end
    
    # Find on workflow state again, using the RDF dupes
    def test_find_wf_state_single_on_rdf
      qry = DbQuery.new(:EXPRESSION, :workflow_state, 0).convert_rdf
      result = qry.execute
      assert_equal(1, result.size)
      assert_kind_of(Source, result[0])
      assert_equal("http://foo_one", result[0].uri.to_s)
    end
    
    # Find by type on RDF
    def test_find_type_on_rdf
      qry = DbQuery.new(:EXPRESSION, :type, N::FOO::eatthis)
      qry = qry.convert_rdf
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_two", result[0].uri.to_s)
    end
    
  end
end
