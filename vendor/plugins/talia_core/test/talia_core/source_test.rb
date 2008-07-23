require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  
  #  class Source
  #    def instantiate_source_or_rdf_object # Need since class may be loaded later
  #    end
  #    
  #    public :instantiate_source_or_rdf_object
  #  end
  
  # Test the SourceType class
  class SourceTest < Test::Unit::TestCase

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
      
      @params = {"uri"=>"#{N::LOCAL}Guinigi_family", "predicates_attributes"=>@predicates_attributes }
        
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
          type = ActiveSource.new("http://www.interestingrelations.org/book")
          type.save!
          src.types << type
          src.save!
        end
      end
      
      setup_once(:data_source) do
        data_source = Source.new("http://www.test.org/source_with_data")
        data_source.primary_source = false
        text = DataTypes::SimpleText.new
        text.location = "text.txt"
        image = DataTypes::ImageData.new
        image.location = "image.jpg"
        data_source.data_records << text
        data_source.data_records << image
        data_source.save!
        data_source
      end
      
      setup_once(:test_type) do
        type = ActiveSource.new('http://www.type.test/the_type')
        type.save!
        type
      end
    end
    
    
    # Check that no .uri method got added to the String class
    def test_string_sanity
      assert(!'foo'.respond_to?(:uri), "Someone added an 'uri' method to the String class. This will cause problems.")
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
    def test_types
      # rec = SourceRecord.new
      source = TestHelper.make_dummy_source("http://www.newstuff.org/createtypes", N::FOAF.Person, N::FOAF.Foe)
      assert_not_nil(source)
      assert_equal(2, source.types.size)
      assert_not_nil(source.types.each { |type| type.to_s == N::FOAF.Person.to_s} )
    end
    
    # test grouping by types
    def test_grouping
      TestHelper.make_dummy_source("http://groupme/source1", N::FOAF.Goat, N::FOAF.Bee)
      TestHelper.make_dummy_source("http://groupme/source2", N::FOAF.Goat)
      TestHelper.make_dummy_source("http://groupme/source3", N::FOAF.Bee)
      results = Source.groups_by_property(:type, [ N::FOAF.Goat, N::FOAF.Bee ])
      assert_equal(2, results.size)
      assert_equal(2, results[N::FOAF.Goat].size)
      assert_equal(2, results[N::FOAF.Bee].size)
    end
    
    # Tests if the ActiveRecord validation works
    def test_ar_validation
      source = Source.new("http://www.newstuff.org/my_first")
      assert(!Source.exists?(source.uri))
      source.primary_source = false
      errors = ""
      assert(source.valid?, source.errors.each_full() { |msg| errors += ":" + msg })
      
      # Now check if the uri validation works
      source.uri = "foobar"
      assert(!source.valid?)
      source.uri = "foo:bar"
      assert(source.valid?)
    end
    
    # Test load/save for active record
    def test_save_with_workflow
      @valid_source.workflow = Workflow::PublicationWorkflow.new
      @valid_source.save!
      assert(Source.exists?(@valid_source.uri))
      assert_kind_of(Workflow::PublicationWorkflow, Source.new(@valid_source.uri).workflow)
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
      source_loaded['http://loadsavetest/name'] << '4'
      source_loaded.save
      
      source_reloaded = Source.find(@valid_source.uri)
      assert_equal('4', source_reloaded['http://loadsavetest/name'][0])
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
    def test_relations
      @valid_source.default::rel_it << Source.new("http://foobar.com/")
      assert_kind_of(SemanticCollectionWrapper, @valid_source.default::rel_it)
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
    
    def test_find_with_local_name
      assert_nothing_raised ActiveRecord::RecordNotFound do
        assert Source.find('home_source')
      end
    end
    
    # Test the xml create
    def test_create_xml
      # TODO: Make a real test when it's worth it
      source = Source.new("http://www.newstuff.org/my_first")
      source.types << @test_type
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
      # and one for the default type
      assert_equal(2, my_source.direct_predicates.size)
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

      assert_equal(2, source.grouped_direct_predicates.size)
      predicates = source.grouped_direct_predicates['default']
      predicates.each do |group, source_list|
        source_list.flatten.each do |source|
          assert_kind_of(SourceTransferObject, source)
        end
      end
      assert_included predicates.keys, 'historical_character'
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
      source = create_source('http://star-warz.org/')
      @predicates_attributes[2] = @predicates_attributes[2].merge({'should_destroy' => '1'})
      @predicates_attributes << {"name"=>"in_epoch", "uri"=> N::LOCAL.to_s, "should_destroy"=>"", "namespace"=>"talias", "id"=>"", "titleized"=>"Paolo Guinigi"}
      source.predicates_attributes = @predicates_attributes
      source.save_predicates_attributes
      
      assert_source_exists "#{N::LOCAL}Paolo_Guinigi"
      source = create_source('http://star-warz.org/') # force the source reload
      # Expected size is equal to 5, because @predicates_attributes
      # contains 6 sources, but 1 is marked for destroy.
      assert_equal(5, source.direct_predicates_objects.size)
    end

    def test_normalize_uri
      assert_equal("#{N::LOCAL}LocalSource", Source.normalize_uri(N::LOCAL.to_s, 'LocalSource'))
      assert_equal("#{N::LOCAL}Local_Source", Source.normalize_uri(N::LOCAL.to_s, 'Local Source'))
      assert_equal("http://star-wars.org/obi-wan-kenobi", Source.normalize_uri('http://star-wars.org/obi-wan-kenobi').to_s)
    end
    
    def test_extract_attributes
      source = TestHelper.make_dummy_source("http://star-wars.org/")
      attributes, rdf_attributes = source.send(:extract_attributes!, @params)

      assert_equal(%w( uri ), attributes.keys)
      rdf_attributes['predicates_attributes'].each do |attributes_hash|
        assert_kind_of Hash, attributes_hash
      end
    end
    
    def test_instantiate_source_or_rdf_object
      source = TestHelper.make_dummy_source("http://springfield.org/")

      attributes = { 'uri' => N::LOCAL.to_s, 'titleized' => 'Homer Simpson', 'source' => 'true' }
      result = source.send :instantiate_source_or_rdf_object, attributes
      assert_kind_of(Source, result)
      assert_equal("#{N::LOCAL}Homer_Simpson", result.to_s)
      
      attributes.merge!('titleized' => %("Homer Simpson"))
      result = source.send :instantiate_source_or_rdf_object, attributes
      assert_equal(%(Homer Simpson), result)
            
      attributes.merge!('titleized' => "http://springfield.org/Homer_Simpson")
      result = source.send :instantiate_source_or_rdf_object, attributes
      assert_kind_of(Source, result)
      assert_equal("http://springfield.org/Homer_Simpson", result.to_s)
      
      attributes.merge!('titleized' => "Homer Simpson", 'uri' => nil, 'source' => nil)
      result = source.send :instantiate_source_or_rdf_object, attributes
      assert_equal(%(Homer Simpson), result)
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
      assert_equal('http://localnode.org/something', attribute_value) 
    end
    
    # Write an db attribute by symbol
    def test_write_access_db_symbol
      source = Source.new('http://localnode.org/something')
      source[:uri] = "http://somethingelse.com/"
      assert_equal(source.uri.to_s, "http://somethingelse.com/")
    end
    
    # Read the uri
    def test_access_db_string
      source = Source.new('http://localnode.org/something') 
      attribute_value = source.uri
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
      assert_raises(ArgumentError) { @valid_source.predicate(:idontexist, "something") }
    end
    
    def test_titleized
      assert_equal("Home Source", @local_source.titleized)
    end
    
    # Test find :first
    def test_find_first
      source = Source.find(:first)
      assert_kind_of(Source, source)
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
    
    def test_rdf_props
      flunk
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
      assert_kind_of(DataTypes::SimpleText, data.first)
    end
    
    # Test if accessing the data on a Source works
    def test_data_access_by_type_and_location
      data = @data_source.data("ImageData", "image.jpg")
      assert_kind_of(DataTypes::ImageData, data)
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
    
    def test_assign_object
      assert(!ActiveSource.exists?(uri = 'http://assignobject_source'))
      src = Source.new(uri)
      src.rdfs::something << Source.new(uri + '_target')
      src.save!
      assert(ActiveSource.exists?(uri))
      assert(ActiveSource.exists?(uri + '_target'))
    end
    
  end
end
 