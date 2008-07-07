# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  
  # Test the ActiveSource
  class ActiveSourceTest < Test::Unit::TestCase
    fixtures :active_sources, :semantic_properties, :semantic_relations
    
    def setup
      setup_once(:rdf_res) do
        TestHelper.flush_rdf
        active_sources(:multirel).send(:create_rdf) # Update the rdf
        active_sources(:multirel).rdf
      end
    end
    
    def test_direct_predicates
      assert_equal(3, @rdf_res.direct_predicates.size, "Elements #{@rdf_res.direct_predicates}")
    end
    
    def test_accessor
      props = @rdf_res['http://testvalue.org/multirel']
      assert_equal(3, props.size)
      assert(props.include?(active_sources(:testy)))
      assert(props.include?(semantic_properties(:other_value).value), "Actually contains #{props}")
    end
    
  end
end
