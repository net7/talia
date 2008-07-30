require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  
  # Test the RdfResource class
  class RdfResourceTest < Test::Unit::TestCase
    
    def setup
      setup_once(:flush) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_create
      res = make_dummy_resource("http://resource_created_test/")
      assert_equal("http://resource_created_test/", res.uri)
    end
    
    def test_assign_property
      res = make_dummy_resource("http://test_assign_property")
      res["http://dummyres.org"] << "foo"
      prop = res["http://dummyres.org"]
      assert_equal(1, prop.size)
      assert_equal("foo", prop[0])
    end
    
    def test_assign_source_relation
      res = make_dummy_resource("http://test_assign_source_relation")
      res["http://dummyrel"] << Source.new("http://dummyrelatedsource")
      prop = res["http://dummyrel"]
      assert_equal(1, prop.size)
      assert_kind_of(Source, prop[0])
      assert_equal("http://dummyrelatedsource", prop[0].uri.to_s)
    end
    
    def test_types
      res = make_dummy_resource("http://test_types")
      res.types << N::SourceClass.new(N::RDF::test)
      assert_equal(RdfResource.default_types.size + 2, res.types.size, "Wrong number of types: #{res.types}")
      assert(!res.types.include?(N::RDF::foo)) # negative check, just to be sure
      assert(res.types.include?(N::RDF::test))
      assert_kind_of(N::SourceClass, res.types[0])
      # check the default types
      RdfResource.default_types.each do |def_type|
        assert(res.types.include?(def_type))
      end
    end
    
    def test_default_types
      # Check if there are the default types on a freshly created resource
      res = RdfResource.new("http://test_default_types")
      assert_equal(RdfResource.default_types.size, res.types.size)
    end
    
    def test_direct_predicates
      res = make_dummy_resource("http://test_predicates")
      res[N::RDFS::test_pred] << "foo"
      assert(res.direct_predicates.size > 0, "No direct_predicates found")
      assert(res.direct_predicates.include?(N::RDFS::test_pred), "test predicate not found")
    end 
    
    def test_inverse_predicates
      target = make_dummy_resource("http://test_pred_target")
      source = make_dummy_resource("http://test_pred_source")
      source[N::RDF::test_pred_rel] << target
      assert(target.inverse_predicates.size > 0, "No inverse predicate found")
      assert(target.inverse_predicates.include?(N::RDF::test_pred_rel))
    end
    
    def test_inverse
      target = make_dummy_resource("http://test_target")
      source = make_dummy_resource("http://test.source")
      source[N::RDF::foo] << target
      props = target.inverse[N::RDF::foo]
      assert_equal(1, props.size)
      assert_kind_of(Source, props[0])
      assert_equal(source.uri, props[0].uri.to_s)
    end
    
    def test_save
      res = make_dummy_resource("http://test_save")
      res[N::RDF::test] << "foo"
      res.save
      
      # Check if the defaul type was written
      rdfs_prop = Query.new(N::SourceClass).distinct(:t).where(res,N::RDF::type,:t).execute
      assert_equal(2, rdfs_prop.size)
      assert(rdfs_prop.include?(N::RDFS.Resource))
    end
    
    private
    
    # Make a dummy resource with a saved source in the background
    def make_dummy_resource(uri)
      make_dummy_source(uri)
      RdfResource.new(uri)
    end
    
  end
end
