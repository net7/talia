require 'test/unit'
require File.dirname(__FILE__) + "/../lib/talia_core"

# Load the helper class
require File.dirname(__FILE__) + '/test_helper'

module TaliaCore
  
  # Test the SourceType class
  class SourceTest < Test::Unit::TestCase
 
    # Establish the database connection for the test
    TestHelper.startup
    
    N::Namespace.shortcut(:meetest, "http://www.meetest.org/me/")
    N::URI.shortcut(:test_uri, "http://www.testuri.com/bar")
    N::Predicate.shortcut(:test_predicate, "http://www.meetest.org/my_predicate")
    N::SourceClass.shortcut(:test_source, "http://www.meetest.org/test_source")
    N::Namespace.shortcut(:foaf, "http://www.foaf.org/")
    
    def setup
      TestHelper.fixtures
      TestHelper.flush_rdf
      SourceRecord.delete_all
      print RDFS::Resource.find_all
      @test_source = Source.new("http://www.test.org/test/")
      @valid_source = Source.new("http://www.test.org/valid")
      @valid_source.workflow_state = 3
      @valid_source.primary_source = false
      
      @local_source = Source.new(N::LOCAL + "home_source")
      @local_source.workflow_state = 42
      @local_source.primary_source = false
      
      (1..3).each do |n|
        src = Source.new("http://www.typedthing.com/element#{n}")
        src.workflow_state = 0
        src.primary_source = false
        src.types << "http://www.interestingrelations.org/book"
        src.save!
      end
    end
    
    def test_created_helper
      assert(Source.exists?("http://www.typedthing.com/element1"))
    end
    
    # Test if a source object can be created correctly with no type information
    def test_create_typeless
      # rec = SourceRecord.new
      source = Source.new("http://www.newstuff.org/my_nuff")
      assert_not_nil(source)
      assert_equal(0, source.types.size)
    end
    
    # Test if a source object can be created correctly
    def test_create_types
      # rec = SourceRecord.new
      source = Source.new("http://www.newstuff.org/createtypes", N::FOAF.Person, N::FOAF.Foe)
      assert_not_nil(source)
      assert_equal(2, source.types.size)
      assert_not_nil(source.types.each { |type| type.to_s == N::FOAF.Person.to_s} )
    end
    
    # Test if the type is initialized correctly
    def test_type_init
      source = Source.new("http://www.newstuff.org/typeinit", N::FOAF.Person)
      assert_equal(source.types[0], N::FOAF.Person)
    end
    
    # Checks if the direct object properties work
    def test_object_properties
      @test_source.workflow_state = 2
      @test_source.name = "Foobar"
      assert_equal(2, @test_source.workflow_state)
      assert_equal("Foobar", @test_source.name)
    end
    
    # Tests if the ActiveRecord validation works
    def test_ar_validation
      source = Source.new("http://www.newstuff.org/my_first")
      source.primary_source = nil
      assert(!source.valid?) # Nothing set, invalid
      source.workflow_state = 3
      source.primary_source = false
      errors = ""
      assert(source.valid?, source.errors.each_full() { |msg| errors += ":" + msg })
      
      # Now check if the uri validation works
      source.uri = "foobar"
      assert(!source.valid?)
      source.uri = "foo:bar "
      assert(!source.valid?)
      source.uri = "foo:bar"
      assert(source.valid?)
      
      # And now for the primary source
      source.primary_source = nil
      assert(!source.valid?)
    end
    
    # Test load/save for active record
    def test_save
      assert_equal(3, @valid_source.workflow_state)
      @valid_source.workflow_state = 15
      @valid_source.save
      assert(Source.exists?(@valid_source.uri))
      assert(SourceRecord.exists_uri?(@valid_source.uri))
      assert_equal(15, Source.new(@valid_source.uri).workflow_state)
    end
    
    # Check loading of Elements
    def test_load
      @valid_source.save
      source_loaded = Source.find(@valid_source.uri)
      assert_kind_of(Source, source_loaded)
      assert_equal(@valid_source.workflow_state, source_loaded.workflow_state)
      assert_equal(@valid_source.primary_source, source_loaded.primary_source)
      assert_equal(@valid_source.uri, source_loaded.uri)
    end
    
    # Load change, and save
    def test_load_save
      @valid_source.save
      source_loaded = Source.find(@valid_source.uri)
      source_loaded.workflow_state = 4
      source_loaded.save
      
      source_reloaded = Source.find(@valid_source.uri)
      assert_equal(4, source_reloaded.workflow_state)
    end
    
    # Test load and save with multiple types
    def test_typed_load_save
      source = Source.new("http://www.newstuff.org/load_save_typed", N::FOAF.Person, N::FOAF.Foe)
      source.workflow_state = 3
      source.primary_source = false
      assert_equal(2, source.types.size)
      
      source.save
      
      source_reloaded = Source.find(source.uri)
      assert_equal(2, source_reloaded.types.size)
    end
    
    # Check if load failure is raised correctly
    def test_load_failure
      # Check for load failure
      assert_raises(ActiveRecord::RecordNotFound) { Source.find("xxxx") }
    end
    
    # Default RDF property
    def test_rdf_default_property
      @test_source.author = "foobar"
      assert_equal(@test_source.author[0], "foobar")
      assert_equal(@test_source.default::author[0], "foobar")
    end
    
    # Direct RDF property
    def test_rdf_direct_property
      @test_source.test_predicate = "moofoo"
      assert_equal(@test_source.test_predicate[0], "moofoo")
      assert_equal(0, @test_source.default::test_predicate.size)
    end
    
    # Namespaced RDF property
    def test_rdf_namespace_property
      @test_source.meetest::something = "somefoo"
      assert_equal(@test_source.meetest::something[0], "somefoo")
    end
    
    # Generic URI property
    def test_rdf_generic_uri
      @test_source.test_uri = "bar"
      assert_equal("bar", @test_source.test_uri[0])
    end
    
    # Check disallowed cases for RDF
    def test_rdf_fail
      assert_raise(SemanticNamingError) { @test_source.test_predicate("foo") }
    end
    
    # Relation properties
    def test_rdf_relations
      @test_source.rel_it = Source.new("http://foobar.com/")
      assert_kind_of(SourcePropertyList, @test_source.rel_it)
      assert_kind_of(Source, @test_source.rel_it[0])
      assert_equal("http://foobar.com/", @test_source.rel_it[0].uri.to_s)
    end
    
    # RDF load and save
    def test_rdf_save_load
      @valid_source.author = "napoleon"
      @valid_source.save
      loaded = Source.find(@valid_source.uri)
      assert_equal("napoleon", loaded.author[0])
    end
    
    # Exists for local sources
    def test_exists_local
      @local_source.save()
      assert(Source.exists?("home_source"))
      assert(!Source.exists?("home_foo"))
    end
    
    # Find for local sources
    def test_find_local
      @local_source.save()
      source = Source.find("home_source")
      assert_kind_of(Source, source)
      assert_equal(42, source.workflow_state)
    end
    
    # Test creation of local sources
    def test_create_local
      source = Source.new("dingens")
      assert(source.uri.local?)
      assert_equal(N::LOCAL + "dingens", source.uri)
    end
    
    # Test the xml create
    def test_create_xml
      # TODO: Make a real test when it's worth it
      source = Source.new("http://www.newstuff.org/my_first", N::FOAF.Person, N::FOAF.Foe)
      source.author = "napoleon"
      print source.to_xml
    end
    
    # Test for direct predicates
    def test_direct_predicates
      my_source = Source.new("http://direct_predicate_haver/")
      my_source.author = "napoleon"
      assert_equal(1, my_source.direct_predicates.size)
      assert_equal(N::DEFAULT::author, my_source.direct_predicates[0])
    end
    
    # Test the Array accessor
    def test_array_accessor
      @valid_source[N::MEETEST::array_test] << "foo"
      assert_equal(@valid_source[N::MEETEST::array_test], @valid_source.meetest::array_test)
      assert_equal("foo", @valid_source[N::MEETEST::array_test][0])
    end
    
        # Read an db attribute by symbol
    def test_read_access_db_symbol
      source = Source.new('http://localnode.org/something') 
      attribute_value = source[:uri]
      assert_not_nil(attribute_value) 
      assert_kind_of(N::URI, attribute_value) 
      assert_equal('http://localnode.org/something', attribute_value.to_s) 
    end
    
    # Write an db attribute by symbol
    def test_write_access_db_symbol
      source = Source.new('http://localnode.org/something')
      source[:uri] = "http://somethingelse.com/"
      assert_equal(source.uri.to_s, "http://somethingelse.com/")
    end
    
    # Read an db attribute by a given string
    def test_access_db_string
      source = Source.new('http://localnode.org/something') 
      attribute_value = source['uri']
      assert_not_nil(attribute_value) 
      assert_kind_of(N::URI, attribute_value) 
      assert_equal('http://localnode.org/something', attribute_value.to_s) 
    end
    
    # Write an db attribute by string
    def test_write_access_db_symbol
      source = Source.new('http://localnode.org/something')
      source['uri'] = "http://somethingelse.com/"
      assert_equal(source.uri.to_s, "http://somethingelse.com/")
    end
    
    # Test the predicate accessor
    def test_predicate_accessor
      assert(@valid_source.predicate_set(:meetest, "array_test_acc", "bla"))
      assert_equal(@valid_source.predicate(:meetest, "array_test_acc"), @valid_source.meetest::array_test_acc)
      assert_equal("bla", @valid_source.predicate(:meetest, "array_test_acc")[0])
    end
    
    # Test for non-existing predicates
    def test_nonexistent_predicate
      assert_nil(@valid_source.predicate(:idontexist, "something"))
    end
    
    # Test the id property
    def test_id
      assert_equal("ihaveanid", Source.new("http://www.something_more.com/bla/ihaveanid").id)
      # to_param is an alias
      assert_equal("ihaveanid", Source.new("http://www.something_more.com/bla/ihaveanid").to_param)
    end
    
    # Test find :all
    def test_find_all
      sources = Source.find(:all)
      assert_kind_of(Array, sources)
      assert_equal(6, sources.size)
    end
    
    # Test find :first
    def test_find_first
      source = Source.find(:first)
      assert_kind_of(Source, source)
    end

    # Test find :all by type
    def test_find_all_type
      sources = Source.find(:all, :type => "http://www.interestingrelations.org/book")
      assert_kind_of(Array, sources)
      assert_equal(3, sources.size)
    end

    # Test find :first by type
    def test_find_first_type
      sources = Source.find(:first, :type => "http://www.interestingrelations.org/book")
      assert_kind_of(Source, sources)
    end
   
    
  end
end
  