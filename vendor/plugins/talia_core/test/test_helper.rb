$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'test/unit'
require "talia_core"
require 'active_record/fixtures'

@@fixtures = [ 'source_records', 'type_records', 'data_records', 'dirty_relation_records']

# Check for the tesly adapter, and load it if it's there
if(File.exists?(File.dirname(__FILE__) + '/tesly_reporter.rb'))
  printf("Continuing with tesly \n")
  require File.dirname(__FILE__) + '/tesly_reporter'
end


module TaliaCore
  class Source
    public :instantiate_source_or_rdf_object
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
      @@fixtures.reverse.each { |f| ActiveRecord::Base.connection.execute "DELETE FROM #{f}" }
      Fixtures.reset_cache if(@@new_ar) # We must reset the cache because the fixtures were deleted
    end
    
    # Setup the fixtures
    def self.fixtures
      flush_db unless(@@new_ar) # When fixtures are cached, there will be no default remove (which fails due to relational constraints)
      fixture_files = @@fixtures.collect { |f| File.join(File.dirname(__FILE__), "#{f}.yml") }
      fixture_files.each do |fixture_file|
        Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures', File.basename(fixture_file, '.*'))  
      end  
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
      src.workflow_state = 0
      src.primary_source = 1
      src.save!
      return src
    end
    
  end
  
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
