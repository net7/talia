$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'test/unit'
require "talia_core"
require 'active_support/testing'
require 'active_support/test_case'
require 'active_record/fixtures'

@@flush_tables = [ 'source_records', 'type_records', 'data_records', 'dirty_relation_records', 'active_sources']

module TaliaCore
  class Source
    public :instantiate_source_or_rdf_object

    def self.create(uri)
      source = self.new(uri)
      source.primary_source = false
      source.save!
      source
    end
  end
  
  class MacroContribution
    # Remove all related sources, used by test suite.
    def clear
      sources.each do |source|
        self.remove source
      end
    end
  end
  
  class TestHelper
    # Check if we have old (1.2.3-Rails) style ActiveRecord without fixture cache
    @@new_ar = Fixtures.respond_to?(:reset_cache)
    
    # connect the database
    def self.startup
      if(!TaliaCore::Initializer.initialized)
        TaliaCore::Initializer.talia_root = File.join(File.dirname(__FILE__))
        TaliaCore::Initializer.environment = "test"
        # run the initializer
        TaliaCore::Initializer.run("talia_core")
      end
    end
    
    # Flush the database
    def self.flush_db
      @@flush_tables.reverse.each { |f| ActiveRecord::Base.connection.execute "DELETE FROM #{f}" }
      Fixtures.reset_cache if(@@new_ar) # We must reset the cache because the fixtures were deleted
    end
    
    # Flush the RDF store
    def self.flush_rdf
      to_delete = Query.new.select(:s, :p, :o).where(:s, :p, :o).execute
      to_delete.each do |s, p, o|
        FederationManager.delete(s, p, o)
      end
    end
    
    # Creates a dummy Source and saves it
    def self.make_dummy_source(uri, *types)
      src = Source.new(uri, *types)
      src.primary_source = 1
      src.save!
      return src
    end
    
    def self.data_record_files
      return ['1.txt', '3.xml', '4.xhtml', '5.hnml', '6.html', '7.xhtml', '8.bmp', '9.fit', '10.gif', '11.jpg', '12.png', '13.tif']
    end
    
  end
  
  TestHelper.startup
  Test::Unit::TestCase.fixture_path=File.join(File.dirname(__FILE__), 'fixtures')
  Test::Unit::TestCase.set_fixture_class :active_sources => TaliaCore::ActiveSource,
    :semantic_properties => TaliaCore::SemanticProperty,
    :semantic_relations => TaliaCore::SemanticRelation
  
  # Add some stuff to the basic test case
  class Test::Unit::TestCase
    
    # Helper to create a variable only once. This should be used from the
    # setup method, and will assign the given block to the given class variable.
    # 
    # The block will only be executed once, after that the value for the
    # class variable will be retrieved from a cache. 
    #
    # This is a workaround because the Ruby test framework doesn't provide 
    # a setup_once method or something like this, and in fact re-creates the
    # Test case object for every single test (go figure). It would be 
    # worth switching to RSpec just for this, but it's a heap of work so... the
    # test framework has just the braindead "fixtures" mechanism...
    #
    # The thing is that's a good practice to have reasonably fine-grained tests,
    # and you often have objects that are re-used often, are read-only for all
    # the tests and expensive to create. So you basically want to create them
    # only once.
    #
    # This thing is less than perfect, but it should work for now. Basically it
    # assumes that all tests for a TestCase will be run in a row, and the
    # setup method will execute before the first test and that no other tests
    # will execute before all tests of the TestCase are executed.
    def setup_once(variable, &block)
      variable = variable.to_sym
      value = self.class.obj_cache[variable]
      unless(value)
        value = block.call
        self.class.obj_cache[variable] = value
      end
      assit_not_nil(value)
      value ||= false # We can't have a nil value (will cause the block to re-run)
      instance_variable_set(:"@#{variable}", value)
    end
    
    # Assert the given condition is false
    def assert_not(condition, message = nil)
      assert !condition, message
    end
    alias_method :assert_false, :assert_not

    # Assert the given collection is empty.
    def assert_empty(condition, message = nil)
      assert condition.empty?, message
    end
    
    # Assert the given collection is not empty.
    def assert_not_empty(condition, message = nil)
      assert_not condition.empty?, message
    end
    
    # Assert the given element is included into the given collection.
    def assert_included(collection, element, message = nil)
      assert collection.include?(element), message
    end
    
    # Assert the given object is instance of one of those classes.
    def assert_kind_of_classes(object, *classes)
      assert_included(classes, object.class,
        "#{object} should be instance of one of those classes: #{classes.to_sentence}")
    end
    
    # Assert the given object is a boolean.
    def assert_boolean(object)
      assert_kind_of_classes(object, TrueClass, FalseClass)
    end
    
    protected 
    
    # Helper variable in the class for setup_once
    def self.obj_cache
      @obj_cache ||= {}
    end
    
  end

end
