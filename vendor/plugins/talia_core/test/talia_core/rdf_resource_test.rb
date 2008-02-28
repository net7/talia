require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  
  # Test the RdfResource class
  class SourceTest < Test::Unit::TestCase
 
    # Establish the database connection for the test
    TestHelper.startup
    
    def setup
      setup_once(:flush) do
        TestHelper.flush_rdf
        TestHelper.flush_db
        true
      end
    end
    
    def test_create
      res = RdfResource.new("http://resource_created_test/")
      assert_equal("http://resource_created_test/", res.uri)
    end
    
    def test_assign_property
      res = RdfResource.new("http://test_assign_property")
      res["http://dummyres.org"] << "foo"
      prop = res["http://dummyres.org"]
      assert_equal(1, prop.size)
      assert_equal("foo", prop[0])
    end
    
    def test_assign_source_relation
      res = RdfResource.new("http://test_assign_source_relation")
      res["http://dummyrel"] << Source.new("http://dummyrelatedsource")
      prop = res["http://dummyrel"]
      assert_equal(1, prop.size)
      assert_kind_of(Source, prop[0])
      assert_equal("http://dummyrelatedsource", prop[0].uri.to_s)
    end
    
    def test_types
      res = RdfResource.new("http://test_types")
      res.types << N::SourceClass.new(N::RDF::test)
      assert_equal(2, res.types.size)
      assert(!res.types.include?(N::RDF::foo))
      assert(res.types.include?(N::RDF::test))
      assert_kind_of(N::SourceClass, res.types[0])
      assert(res.types.include?(N::RDFS.Resource))
    end
    
    def test_inverse
      target = RdfResource.new("http://test_target")
      source = RdfResource.new("http://test.source")
      source[N::RDF::foo] << target
      props = target.inverse[N::RDF::foo]
      assert_equal(1, props.size)
      assert_kind_of(Source, props[0])
      assert_equal(source.uri, props[0].uri.to_s)
    end
    
    def test_save
      res = RdfResource.new("http://test_save")
      res[N::RDF::test] << "foo"
      res.save
      
      # Check if the defaul type was written
      rdfs_prop = Query.new(N::SourceClass).distinct(:t).where(res,N::RDF::type,:t).execute
      assert_equal(1, rdfs_prop.size)
      assert_equal(N::RDFS.Resource, rdfs_prop.first)
    end
    
  end
end
