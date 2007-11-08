require 'test/unit'
require File.dirname(__FILE__) + "/../lib/talia_core"

# Load the helper 
require File.dirname(__FILE__) + '/test_helper'

module TaliaCore
  
  # Test the RdfQuery class
  class SourceQueryTest < Test::Unit::TestCase
    
    TestHelper::startup
    @@is_setup = false
    
    def setup_db
      # Setup the database things
      TestHelper::flush_rdf()
      TestHelper::flush_db()
      s1 = Source.new("http://foo_one")
      s1.workflow_state = 0
      s1.primary_source = true
      s1.save!
      s1.foo::workstate = "0"
      s1.foo::primary = "true"
      s1.save!
      s2 = Source.new("http://foo_two", N::FOO::eatthis, N::FOO::hello)
      s2.workflow_state = 1
      s2.primary_source = false
      s2.save!
      s2.foo::type = "eatthis"
      s2.foo::type = "hello"
      s2.foo::workstate = "1"
      s2.foo::primary = "false"
      s2.save!
      s3 = Source.new("http://foo_three", N::FOO::barme, N::FOO::hello)
      s3.workflow_state = 1
      s3.primary_source = true
      s3.save!
      s3.foo::type = "barme"
      s3.foo::type = "hello"
      s3.foo::workstate = "1"
      s3.foo::primary = "true"
      s3.save!
    end
    
    def setup
      # we only need to run the db-setup once for this
      setup_db if(!@@is_setup)
      @@is_setup = true
    end
  
    # Creating a simple rdf query
    def test_rdf_simple
      qry = SourceQuery.new(:operation => :EXPRESSION, :property => N::FOO::workstate, :value => "0")
      assert_kind_of(RdfQuery, qry)
      result = qry.execute
      assert_equal(1, result.size)
      assert_kind_of(Source, result[0])
      assert_equal("http://foo_one", result[0].uri.to_s)
    end
    
    # Creating a simple database query
    def test_db_simple
      qry = SourceQuery.new(:operation => :EXPRESSION, :property => :workflow_state, :value => 0)
      assert_kind_of(DbQuery, qry)
      result = qry.execute
      assert_equal(1, result.size)
      assert_kind_of(Source, result[0])
      assert_equal("http://foo_one", result[0].uri.to_s)
    end
    
    # Creating a simple database query and force it to rdf
    def test_force_simple
      qry = SourceQuery.new(:operation => :EXPRESSION, :property => :workflow_state, :value => 0, :force_rdf => true)
      assert_kind_of(RdfQuery, qry)
      result = qry.execute
      assert_equal(1, result.size)
      assert_kind_of(Source, result[0])
      assert_equal("http://foo_one", result[0].uri.to_s)
    end
    
    # Creating an "and" RDF query
    def test_rdf_and
      qry = SourceQuery.new(:conditions => {
          N::FOO::type => "hello",
          N::FOO::workstate => "1",
          N::FOO::primary => "true"
        })
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_three", result[0].uri.to_s)
    end
    
    # Creating an "or" RDF query
    def test_rdf_or
      qry = SourceQuery.new(:operation => :OR, :conditions => {     
        N::FOO::type => "hello",
        N::FOO::workstate => "1",
        N::FOO::primary => "true" })
      result = qry.execute
      assert_equal(3, result.size)
    end
    
    # Creating an "and" database query
    def test_db_and
      qry = SourceQuery.new(:operation => :AND, :conditions => {
        :workflow_state => 1,
        :primary_source => false })
      assert_kind_of(DbQuery, qry)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_two", result[0].uri.to_s)
    end
    
    # Creating an "and" database query, forcing to RDF
    def test_db_and_force
      qry = SourceQuery.new(:operation => :AND, :conditions => {
        :workflow_state => 1,
        :primary_source => false },
        :force_rdf => true
      )
      assert_kind_of(RdfQuery, qry)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_two", result[0].uri.to_s)
    end
    
    # Creating an "or" database query
    def test_db_or
      qry = SourceQuery.new(:operation => :OR, :conditions => {
        :workflow_state => 1,
        :primary_source => false } )
      result = qry.execute
      assert_equal(2, result.size)
    end
    
    # Creating a mixed "and" query
    def test_mixed_and
      qry = SourceQuery.new(:operation => :AND, :conditions => {
        N::FOO::workstate => "1",
        :primary_source => true })
      assert_kind_of(MixedQuery, qry)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_three", result[0].uri.to_s)
    end
    
    # Creating a mixed "and" query, forced to rdf
    def test_mixed_and_force
      qry = SourceQuery.new(:operation => :AND, :conditions => {
        N::FOO::workstate => "1",
        :primary_source => true },
        :force_rdf => true )
      assert_kind_of(RdfQuery, qry)
      result = qry.execute
      assert_equal(1, result.size)
      assert_equal("http://foo_three", result[0].uri.to_s)
    end
    
    # Creating a mixed "or" query
    def test_mixed_or
      qry = SourceQuery.new(:operation => :OR, :conditions =>  {
       N::FOO::workstate => "1",
       :primary_source => true }) 
      assert_kind_of(MixedQuery, qry)
      result = qry.execute
      assert_equal(3, result.size)
    end
    
    # Test offset and limit for DB queries
    def test_offset_limit_db
      qry = SourceQuery.new(:conditions => { :workflow_state => 1 }, :limit => 1)
      assert_kind_of(DbQuery, qry)
      result = qry.execute
      assert_equal(1, result.size)
      uri = result[0].uri.to_s
      assert((uri == "http://foo_three") || (uri == "http://foo_two"))
      # Now we test if we can get the other result with the offset
      qry = SourceQuery.new(:conditions => { :workflow_state => 1 }, :limit => 1, :offset => 1)
      result = qry.execute
      assert_equal(1, result.size)
      uri2 = result[0].uri.to_s
      assert((uri2 == "http://foo_three") || (uri2 == "http://foo_two"))
      assert_not_equal(uri, uri2)
    end
    
    # Test offset and limit for RDF queries
    def test_offset_limit_rdf
      qry = SourceQuery.new(:conditions => { N::FOO::workstate => "1" }, :limit => 1)
      assert_kind_of(RdfQuery, qry)
      result = qry.execute
      assert_equal(1, result.size)
      uri = result[0].uri.to_s
      assert((uri == "http://foo_three") || (uri == "http://foo_two"))
      # Now we test if we can get the other result with the offset
      qry = SourceQuery.new(:conditions => { N::FOO::workstate => "1" }, :limit => 1, :offset => 1)
      result = qry.execute
      assert_equal(1, result.size)
      uri2 = result[0].uri.to_s
      assert((uri2 == "http://foo_three") || (uri2 == "http://foo_two"))
      assert_not_equal(uri, uri2)
    end
    
  end
end
    
