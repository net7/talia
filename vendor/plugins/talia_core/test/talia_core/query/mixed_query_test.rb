require 'test/unit'

# Load the helper 
require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

module TaliaCore
  
  # Test the RdfQuery class
  class MixedQueryTest < Test::Unit::TestCase
    
    TestHelper::startup
    
    def setup
      setup_once(:flush) do
        # Setup the database things
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
        s3.save!
      end
    end
    
    # Test simple AND operation
    def test_simple_and
      rdf_qry = RdfQuery.new(:EXPRESSION, N::FOO::type, "hello")
      db_qry = DbQuery.new(:EXPRESSION, :primary_source, false)
      qry = MixedQuery.new(:AND, rdf_qry, db_qry)
      results = qry.execute
      assert_equal(1, results.size)
      assert_kind_of(Source, results[0])
      assert_equal("http://foo_two", results[0].uri.to_s)
    end
    
    # Test a simple OR operation
    def test_simple_or
      rdf_qry = RdfQuery.new(:EXPRESSION, N::FOO::type, "barme")
      db_qry = DbQuery.new(:EXPRESSION, :workflow_state, 0)
      qry = MixedQuery.new(:OR, rdf_qry, db_qry)
      results = qry.execute
      assert_equal(2, results.size)
      assert(results[0].uri.to_s == "http://foo_three" || results[0].uri.to_s == "http://foo_one")
      assert(results[1].uri.to_s == "http://foo_three" || results[1].uri.to_s == "http://foo_one")
      assert_not_equal(results[0].uri.to_s, results[1].uri.to_s)
    end
    
    # Test a more complex or operation
    def test_or
      rdf_qry = RdfQuery.new(:EXPRESSION, N::FOO::type, "barme")
      rdf_qry = rdf_qry.or(RdfQuery.new(:EXPRESSION, N::FOO::type, "eatthis"))
      db_qry = DbQuery.new(:EXPRESSION, :workflow_state, 0)
      qry = MixedQuery.new(:OR, rdf_qry, db_qry)
      results = qry.execute
      assert_equal(3, results.size)
    end
    
    # Test a query where there is duplication between the db and rdf results
    def test_or_dup_remove
      rdf_qry = RdfQuery.new(:EXPRESSION, N::FOO::type, "barme")
      rdf_qry = rdf_qry.or(RdfQuery.new(:EXPRESSION, N::FOO::type, "eatthis"))
      db_qry = DbQuery.new(:EXPRESSION, :workflow_state, 1)
      qry = MixedQuery.new(:OR, rdf_qry, db_qry)
      results = qry.execute
      assert_equal(2, results.size)
      assert(results[0].uri.to_s == "http://foo_three" || results[0].uri.to_s == "http://foo_two")
      assert(results[1].uri.to_s == "http://foo_three" || results[1].uri.to_s == "http://foo_two")
      assert_not_equal(results[0].uri.to_s, results[1].uri.to_s)
    end
    
    
    # Test a more complex and operation
    def test_and
      rdf_qry = RdfQuery.new(:EXPRESSION, N::FOO::type, "hello")
      db_qry = DbQuery.new(:EXPRESSION, :workflow_state, 1)
      db_qry2 = DbQuery.new(:EXPRESSION, :primary_source, true)
      qry = MixedQuery.new(:AND, rdf_qry, db_qry, db_qry2)
      results = qry.execute
      assert_equal(1, results.size)
      assert_equal("http://foo_three", results[0].uri.to_s)
    end
    
  end
end
    