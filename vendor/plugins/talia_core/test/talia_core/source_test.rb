require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  
  # Test the SourceType class
  class SourceTest < Test::Unit::TestCase
 
    # Establish the database connection for the test
    TestHelper.startup
    
    N::Namespace.shortcut(:meetest, "http://www.meetest.org/me/")
    N::URI.shortcut(:test_uri, "http://www.testuri.com/bar")
    N::Predicate.shortcut(:test_predicate, "http://www.meetest.org/my_predicate")
    N::Namespace.shortcut(:foaf, "http://www.foaf.org/")
    
    def setup
      @predicates_attributes = [{"name"=>"uri", "uri"=>"#{N::LOCAL}Guinigi_Family", "namespace"=>"talia_db", "titleized"=>"Guinigi Family", "should_destroy" => ""},
        {"name"=>"uri", "uri"=>"#{N::LOCAL}", "namespace"=>"talia_db", "titleized"=>%("Homer Simpson"), "should_destroy" => ""},
        {"name"=>"uri", "uri"=>"#{N::LOCAL}", "namespace"=>"talia_db", "titleized"=>"http://springfield.org/Homer_Simpson", "should_destroy" => ""},
        {"name"=>"type", "uri"=>"http://www.w3.org/2000/01/rdf-schema#Resource", "namespace"=>"rdf", "titleized"=>"Resource", "should_destroy" => ""},
        {"name"=>"type", "uri"=>"http://xmlns.com/foaf/0.1/Group", "should_destroy"=>"", "namespace"=>"rdf", "id"=>"Group", "titleized"=>"Group", "should_destroy" => ""}]
      
      @params = {"uri"=>"#{N::LOCAL}Guinigi_family", "primary_source"=>"true",
        "predicates_attributes"=>@predicates_attributes }
        
      setup_once(:flush) do
        TestHelper.flush_rdf
        TestHelper.flush_db
        true
      end
      
      setup_once(:test_source) do
        Source.new("http://www.test.org/test/")
      end
      
      setup_once(:valid_source) do
        valid_source = Source.new("http://www.test.org/valid")
        valid_source.primary_source = false
        valid_source.save!
        valid_source
      end
      assert(Source::exists?(@valid_source.uri))
      
      setup_once(:local_source) do
        local_source = Source.new(N::LOCAL + "home_source")
        local_source.primary_source = false
        local_source.save!
        local_source
      end
      
      setup_once(:dummy_sources) do
        (1..3).each do |n|
          src = Source.new("http://www.typedthing.com/element#{n}")
          src.primary_source = false
          src.types << "http://www.interestingrelations.org/book"
          src.save!
        end
      end
      
      setup_once(:data_source) do
        data_source = Source.new("http://www.test.org/source_with_data")
        data_source.primary_source = false
        text = SimpleText.new
        text.location = "text.txt"
        image = ImageData.new
        image.location = "image.jpg"
        data_source.data_records << text
        data_source.data_records << image
        data_source.save!
        data_source
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
    
    # test grouping by types
    def test_grouping
      TestHelper.make_dummy_source("http://groupme/source1", N::FOAF.Goat, N::FOAF.Bee)
      TestHelper.make_dummy_source("http://groupme/source2", N::FOAF.Goat).save!
      TestHelper.make_dummy_source("http://groupme/source3", N::FOAF.Bee).save!
      results = Source.groups_by_property(:type, [ N::FOAF.Goat, N::FOAF.Bee ])
      assert_equal(2, results.size)
      assert_equal(2, results[N::FOAF.Goat].size)
      assert_equal(2, results[N::FOAF.Bee].size)
    end
    
    # Test if the type is initialized correctly
    def test_type_init
      source = Source.new("http://www.newstuff.org/typeinit", N::FOAF.Person)
      assert_equal(source.types[0], N::FOAF.Person)
    end
    
    # Checks if the direct object properties work
    def test_object_properties
      @test_source.name = "Foobar"
      assert_equal("Foobar", @test_source.name)
    end
    
    # Tests if the ActiveRecord validation works
    def test_ar_validation
      source = Source.new("http://www.newstuff.org/my_first")
      assert(!Source.exists?(source.uri))
      assert(!source.valid?) # Nothing set, invalid
      source.primary_source = false
      errors = ""
      assert(source.valid?, source.errors.each_full() { |msg| errors += ":" + msg })
      
      # Now check if the uri validation works
      source.uri = "foobar"
      assert(!source.valid?)
      source.uri = "foo:bar"
      assert(source.valid?)
      
      # And now for the primary source
      source.primary_source = nil
      assert(!source.valid?)
    end
    
    # Test load/save for active record
    def test_save_with_workflow
      @valid_source.workflow = PublicationWorkflowRecord.new
      @valid_source.save
      assert(Source.exists?(@valid_source.uri))
      assert(SourceRecord.exists_uri?(@valid_source.uri))
      assert_kind_of(PublicationWorkflowRecord, Source.new(@valid_source.uri).workflow)
    end
    
    # Check loading of Elements
    def test_load
      @valid_source.save
      source_loaded = Source.find(@valid_source.uri)
      assert_kind_of(Source, source_loaded)
      assert_equal(@valid_source.primary_source, source_loaded.primary_source)
      assert_equal(@valid_source.uri, source_loaded.uri)
    end
    
    # Load change, and save
    def test_load_save
      @valid_source.save
      source_loaded = Source.find(@valid_source.uri)
      source_loaded.name = '4'
      source_loaded.save
      
      source_reloaded = Source.find(@valid_source.uri)
      assert_equal('4', source_reloaded.name)
    end
    
    # Test load and save with multiple types
    def test_typed_load_save
      source = Source.new("http://www.newstuff.org/load_save_typed", N::FOAF.Person, N::FOAF.Foe)
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
    
    # Direct RDF property
    def test_rdf_direct_property
      @valid_source.default::test_predicate << "moofoo"
      assert_equal(@valid_source.default::test_predicate[0], "moofoo")
      assert_equal(1, @valid_source.default::test_predicate.size)
    end
    
    # Namespaced RDF property
    def test_rdf_namespace_property
      @valid_source.meetest::something << "somefoo"
      assert_equal(@valid_source.meetest::something[0], "somefoo")
    end
    
    # Check disallowed cases for RDF
    def test_rdf_fail
      assert_raise(ArgumentError) { @valid_source.test_predicate("foo") }
    end
    
    # Relation properties
    def test_rdf_relations
      @valid_source.default::rel_it << Source.new("http://foobar.com/")
      assert_kind_of(PropertyList, @valid_source.default::rel_it)
      assert_kind_of(Source, @valid_source.default::rel_it[0])
      assert_equal("http://foobar.com/", @valid_source.default::rel_it[0].uri.to_s)
    end
    
    # RDF load and save
    def test_rdf_save_load
      @valid_source.default::hero << "napoleon"
      @valid_source.save
      loaded = Source.find(@valid_source.uri)
      assert_equal("napoleon", loaded.default::hero[0])
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
    end
    
    # Test limit
    def test_find_limit
      result = Source.find(:all, :limit => 2)
      assert_equal(2, result.size)
    end
    
    def test_should_return_a_list_of_sources_for_given_uri_token
      assert_not_empty Source.find_by_uri_token('1') # source1 fixture
      assert_empty Source.find_by_uri_token('org')
    end

    def test_new_record
      assert Source.new('nu').new_record?
      assert_not Source.find(:first).new_record?
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
      source.primary_source = false
      source.save!
      source.default::author << "napoleon"
      source.save!
      print source.to_xml
      print source.to_rdf # also check rdf
    end
    
    # Test for direct predicates
    def test_direct_predicates
      my_source = TestHelper.make_dummy_source("http://direct_predicate_haver/")
      my_source.default::author << "napoleon"
      # Expected size of direct predicates: One for the predicate set above
      # one for the rdf:type and one for each database dummy
      expected_size = SourceRecord.content_columns.size + 2
      assert_equal(expected_size, my_source.direct_predicates.size)
      assert(my_source.direct_predicates.include?(N::DEFAULT::author))
    end
    
    # Test for inverse predicates
    def test_inverse_predicates
      source = TestHelper.make_dummy_source("http://predicate_source/")
      target = TestHelper.make_dummy_source("http://predicate_target/")
      source.foo::invtest << target
      assert(target.inverse_predicates.size > 0, "No inverse predicates")
      assert(target.inverse_predicates.include?(N::FOO::invtest), "Inverse predicate not found.")
    end
    
    # Test the Array accessor
    def test_array_accessor
      @valid_source[N::MEETEST::array_test] << "foo"
      assert_equal(@valid_source[N::MEETEST::array_test], @valid_source.meetest::array_test)
      assert_equal("foo", @valid_source[N::MEETEST::array_test][0])
    end
    
    def test_grouped_direct_predicates_should_collect_rdf_objects
      source = TestHelper.make_dummy_source("http://direct_predicate_for_napoleon/")
      source.default::historical_character << Source.new("#{N::LOCAL}napoleon")
      source.default::historical_character << "Giuseppe Garibaldi"
      # Expected size of direct predicates:
      # Two for the predicates set above
      # one for the DatabaseDupes and one for 22-rdf-syntax-ns
      assert_equal(3, source.grouped_direct_predicates.size)
      assert_included source.grouped_direct_predicates['default'].keys, 'historical_character'
    end
    
    def test_direct_predicates_objects
      source = TestHelper.make_dummy_source("http://star-wars.org/")
      source.default::jedi_knight << Source.new("http://star-wars.org/luke-skywalker")
      source.default::jedi_knight << "Obi-Wan Kenobi"

      assert_included source.direct_predicates_objects, "http://star-wars.org/luke-skywalker"
      assert_included source.direct_predicates_objects, "Obi-Wan Kenobi"
    end
    
    def test_associated
      source = TestHelper.make_dummy_source("http://star-wars.org/")
      associated_source = Source.new("http://star-wars.org/luke-skywalker")
      source.default::jedi_knight << associated_source
      assert(source.associated?(associated_source))
    end
    
    def test_predicates_attributes_setter
      source = TestHelper.make_dummy_source("http://lucca.org/")
      source.predicates_attributes = @predicates_attributes

      assert_equal("#{N::LOCAL}Guinigi_Family", source.predicates_attributes.first['uri'])
      assert_equal('talia_db', source.predicates_attributes.first['namespace'])
      assert_equal('Guinigi Family', source.predicates_attributes.first['titleized'])
      assert_kind_of(Source, source.predicates_attributes.first['object'])
    end

    def test_save_predicates_attributes
      source = TestHelper.make_dummy_source("http://star-wars.org/")
      @predicates_attributes[2] = @predicates_attributes[2].merge({'should_destroy' => '1'})
      @predicates_attributes << {"name"=>"in_epoch", "uri"=> N::LOCAL.to_s, "should_destroy"=>"", "namespace"=>"talias", "id"=>"", "titleized"=>"Paolo Guinigi"}
      source.predicates_attributes = @predicates_attributes
      source.save_predicates_attributes
      
      assert(Source.exists?("#{N::LOCAL}Paolo_Guinigi"))
      # Expected size is equal to 6, because @predicates_attributes
      # contains 8 sources, but 1 is marked for destroy.
      assert_equal(6, source.direct_predicates_objects.size)
    end

    def test_normalize_uri
      assert_equal("#{N::LOCAL}LocalSource", Source.normalize_uri(N::LOCAL.to_s, 'LocalSource'))
      assert_equal("#{N::LOCAL}Local_Source", Source.normalize_uri(N::LOCAL.to_s, 'Local Source'))
      assert_equal("http://star-wars.org/obi-wan-kenobi", Source.normalize_uri('http://star-wars.org/obi-wan-kenobi').to_s)
    end
    
    def test_extract_attributes
      source = TestHelper.make_dummy_source("http://star-wars.org/")
      source_record_attributes, attributes = source.send(:extract_attributes!, @params)

      assert_equal(%w(uri primary_source), source_record_attributes.keys)
      attributes['predicates_attributes'].each do |attributes_hash|
        assert_kind_of(Hash, attributes_hash)
      end
    end
    
    def test_instantiate_source_or_rdf_object
      source = TestHelper.make_dummy_source("http://springfield.org/")

      attributes = { 'uri' => N::LOCAL.to_s, 'titleized' => 'Homer Simpson' }
      result = source.instantiate_source_or_rdf_object(attributes)
      assert_kind_of(Source, result)
      assert_equal("#{N::LOCAL}Homer_Simpson", result.to_s)
      
      attributes.merge!('titleized' => %("Homer Simpson"))
      result = source.instantiate_source_or_rdf_object(attributes)
      assert_equal(%(Homer Simpson), result)
      
      attributes.merge!('titleized' => "http://springfield.org/Homer_Simpson")
      result = source.instantiate_source_or_rdf_object(attributes)
      assert_kind_of(Source, result)
      assert_equal("http://springfield.org/Homer_Simpson", result.to_s)
    end
    
    def test_each_predicate_attribute
      source = TestHelper.make_dummy_source("http://star-wars.org/")
      source.predicates_attributes = @predicates_attributes
      
      source.send(:each_predicate_attribute) do |namespace, name, object, should_destroy|
        assert_kind_of(Symbol, namespace)
        assert_kind_of(String, name)
        assert_kind_of_classes(object, Source, String)
        assert_boolean should_destroy
      end
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
    
    def test_titleized
      assert_equal("Home Source", @local_source.titleized)
    end

    def test_source_record_id
      assert_nil(Source.new('').source_record_id)
      assert_not_nil(Source.find(:first).source_record_id)
    end
    
    # Test find :all
    def test_find_all
      sources = Source.find(:all)
      assert_kind_of(Array, sources)
      assert_equal(SourceRecord.count, sources.size)
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
    
    # Test find :all without result
    def test_find_all_with_nothing
      sources = Source.find(:all, N::FOO::doesnotexist => "never_found")
      assert_equal(0, sources.size)
    end
    
    # Test find :first without result
    def test_find_first_with_nothing
      sources = Source.find(:first, N::FOO::doesnotexist => "never_found")
      assert_equal(nil, sources)
    end

    # Test find :first by type
    def test_find_first_type
      sources = Source.find(:first, :type => "http://www.interestingrelations.org/book")
      assert_kind_of(Source, sources)
    end
   
    # Test if RDF assignment fails on unsigned Source
    def test_assign_unsaved_fail
      src = Source.new("http://fobar.org/unsaved")
      assert_raise(RuntimeError) { src.meetest::something << "test"  }
    end
    
    # Test find on db element
    def test_find_on_db
      add_src = TestHelper.make_dummy_source("http://fourtythreedummy.one/")
      add_src.name = '43'
      add_src.save
      add_src = TestHelper.make_dummy_source("http://fourtythreedummy.two/")
      add_src.name = '43'
      add_src.save
      sources = Source.find(:all, :name => '43')
      assert_equal(sources.size, 2)
    end
    
    # Test find :first on db element
    def test_find_on_db_first
      add_src = TestHelper.make_dummy_source("http://fourtyfourdummy.one/")
      add_src.name = '44'
      add_src.save
      add_src = TestHelper.make_dummy_source("http://fourtyfourdummy.two/")
      add_src.name = '44'
      add_src.save
      source = Source.find(:first, :name => '44')
      assert(source.uri.to_s == "http://fourtyfourdummy.one/" || source.uri.to_s == "http://fourtyfourdummy.two/")
    end
    
    # Test find on rdf of db elements
    def test_find_on_db_first_rdf
      add_src = TestHelper.make_dummy_source("http://fourtyfivedummy.one/")
      add_src.name = '45'
      add_src.save
      add_src = TestHelper.make_dummy_source("http://fourtyfivedummy.two/")
      add_src.name = '45'
      add_src.save
      source = Source.find(:first, :name => '45', :force_rdf => true)
      assert(source.uri.to_s == "http://fourtyfivedummy.one/" || source.uri.to_s == "http://fourtyfivedummy.two/")
    end
    
    # Test find on rdf
    def test_find_on_rdf
      add_src = TestHelper.make_dummy_source("http://foofoodummy.one/")
      add_src.foo::foofoo = "one"
      add_src.save
      add_src = TestHelper.make_dummy_source("http://foofoodummy.two/")
      add_src.foo::foofoo = "one"
      add_src.save
      sources = Source.find(:all, N::FOO::foofoo => "one")
      assert_equal(2, sources.size)
    end
    
    # Test find :first on RDF
    def test_find_on_rdf
      add_src = TestHelper.make_dummy_source("http://foofoo_two_dummy.one/")
      add_src.foo::foofoo << "two"
      add_src.save
      add_src = TestHelper.make_dummy_source("http://foofoo_two_dummy.two/")
      add_src.foo::foofoo << "two"
      add_src.save
      source = Source.find(:first, N::FOO::foofoo => "two")
      assert(source.uri.to_s == "http://foofoo_two_dummy.one/" || source.uri.to_s == "http://foofoo_two_dummy.two/")
    end
    
    # Test limit and 
    def test_find_on_rdf_limit_offset
      add_src = TestHelper.make_dummy_source("http://foofoo_three_dummy.one/")
      add_src.foo::foofoo << "three"
      add_src.save
      add_src = TestHelper.make_dummy_source("http://foofoo_three_dummy.two/")
      add_src.foo::foofoo << "three"
      add_src.save
      source = Source.find(:first, N::FOO::foofoo => "three")
      sources = Source.find(:all, N::FOO::foofoo => "three", :limit => 1)
      assert_equal(1, sources.size)
      assert_equal(source.uri, sources[0].uri)
      sources2 = Source.find(:all, N::FOO::foofoo => "three", :limit => 1, :offset => 1)
      assert_equal(1, sources2.size)
      assert_not_equal(sources[0], sources2[0])
    end
    
    # Test find on db with limit and offset 
    def test_find_on_db_limit_offset
      add_src = TestHelper.make_dummy_source("http://fourtysixdummy.one/")
      add_src.name = '46'
      add_src.save
      add_src = TestHelper.make_dummy_source("http://fourtysixdummy.two/")
      add_src.name = '46'
      add_src.save
      source = Source.find(:first, :name => '46')
      sources = Source.find(:all, :name => '46', :limit => 1)
      assert_equal(1, sources.size)
      assert_equal(source.uri, sources[0].uri)
      sources2 = Source.find(:all, :name => '46', :limit => 1, :offset => 1)
      assert_equal(1, sources2.size)
      assert_not_equal(sources[0], sources2[0])
    end
    
    # Test the inverse accessor
    def test_inverse
      origin = TestHelper.make_dummy_source("http://inversetest.com/originating")
      origin2 = TestHelper.make_dummy_source("http://inversetest.com/originating2")
      target = TestHelper.make_dummy_source("http://inversetest.com/target")
     
      
      origin.foo::my_friend << target
      origin.foo::coworker << target
      origin2.foo::my_friend << target
      
      inverted = target.inverse[N::FOO::coworker]
      assert_equal(1, inverted.size)
      assert_equal(origin.uri, inverted[0].uri)
      
      # Crosscheck
      assert_equal(2, target.inverse[N::FOO::my_friend].size)
    end
    
    # Test if the save method/db dupes wipes any rdf data
    def test_rdf_safe
      safe = TestHelper.make_dummy_source("http://safehaven.com")
      safe.foo::some_property << "I should be safe!"
      safe.save!
      assert_equal("I should be safe!", safe.foo::some_property[0])
    end
    
    # Test if accessing the data on a Source works
    def test_data_access
      data = @data_source.data
      assert_equal(2, data.size)
    end
    
    # Test if accessing the data on a Source works
    def test_data_access_by_type
      data = @data_source.data("SimpleText")
      assert_equal(1, data.size)
      assert_kind_of(SimpleText, data.first)
    end
    
    # Test if accessing the data on a Source works
    def test_data_access_by_type_and_location
      data = @data_source.data("ImageData", "image.jpg")
      assert_kind_of(ImageData, data)
    end
    
    # Test accessing inexistent data
    def test_data_access_inexistent
      data = @data_source.data("Foo")
      assert_equal(0, data.size)
      data = @data_source.data("SimpleText", "noop.txt")
      assert_nil(data)
    end 
    
    # Test foreign Source
    def test_foreign
      foreign = Source.new("http://www.hypernietzsche.org/ontology/Dossier")
      assert_kind_of(Source, foreign)
      assert(!foreign.local)
    end
    
    # Test equality
    def test_equals
      new_src = Source.new(@test_source.uri)
      assert_equal(new_src, @test_source)
      assert_not_same(new_src, @test_source)
    end    
  end
end
 