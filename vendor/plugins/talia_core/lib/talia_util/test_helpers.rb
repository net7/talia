module TaliaUtil
  
  # Test helper mixin for unit tests
  module TestHelpers
    
    # Test the types of an element. Asserts if the source has the same types as
    # given in the types argument(s)
    def assert_types(source, *types)
      assert_kind_of(TaliaCore::Source, source) # Just to be sure
      type_list = ""
      source.types.each { |type| type_list << "#{type.local_name}\n" }
      assert_equal(types.size, source.types.size, "Type size mismatch: Source has #{source.types.size} instead of #{types.size}.\n#{type_list}")
      types.each { |type| assert(source.types.include?(type), "#{source.uri.loca_name} should have type #{type}\n#{type_list}") }
    end
    
    # Checks if the given property has the values given to this assertion. If
    # a value is an N::URI, this will assert if the property refers to the 
    # Source given by the URI.
    def assert_property(property, *values)
      assert_kind_of(TaliaCore::SemanticCollectionWrapper, property) # Just to be sure
      assert_equal(values.size, property.size, "Expected #{values.size} values instead of #{property.size}")
      values = values.collect { |value| value.is_a?(N::URI) ? TaliaCore::Source.new(value) : value }
      property.each do |value|
        assert(values.include?(value), "Found unexpected value #{value}. Value is a #{value.class}\nExpected:\n#{values.join("\n")}") 
      end
    end
    
    # Creates a dummy Source and saves it
    def make_dummy_source(uri, *types)
      src = TaliaCore::Source.new(uri)
      src.primary_source = true
      types.each do |t| 
        TaliaCore::ActiveSource.new(t).save! unless(TaliaCore::ActiveSource.exists?(:uri => t.to_s))
        src.types << t 
      end
      src.save!
      return src
    end
    
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
    
    # Creates a source for the given uri
    def create_source(uri)
      TaliaCore::Source.create!(uri)
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
    
    # Assert the source for the given uri exists.
    def assert_source_exist(uri, message = nil)
      assert TaliaCore::Source.exists?(uri), message
    end
    alias_method :assert_source_exists, :assert_source_exist
  end
end

# Add some stuff to the basic test case
class Test::Unit::TestCase
  include TaliaUtil::TestHelpers

  protected
  
  # Helper variable in the class for setup_once
  def self.obj_cache
    @obj_cache ||= {}
  end
  
  # Lets the class suppress the fixtures for the tests
  def self.suppress_fixtures
    @suppress_fixtures = true
  end
  
  def self.suppress_fixtures?
    @suppress_fixtures
  end
  
  # Adds the possibility to completely disable the fixture mechanism of rails
  if(method_defined?(:setup_with_fixtures) && method_defined?(:teardown_with_fixtures))
    alias_method :setup_with_fixtures_orig, :setup_with_fixtures
    define_method(:setup_with_fixtures) do
      setup_with_fixtures_orig unless(self.class.suppress_fixtures?)
    end
    alias_method :teardown_with_fixtures_orig, :teardown_with_fixtures
    define_method(:teardown_with_fixtures) do
      teardown_with_fixtures_orig unless(self.class.suppress_fixtures?)
    end
  end
  
end
