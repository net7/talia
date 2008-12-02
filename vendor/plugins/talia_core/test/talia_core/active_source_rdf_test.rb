# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore
  
  # Test the ActiveSource
  class ActiveSourceRdfTest < Test::Unit::TestCase
    fixtures :active_sources, :semantic_properties, :semantic_relations
    
    def setup
      setup_once(:rdf_res) do
        TaliaUtil::Util.flush_rdf
        active_sources(:multirel).send(:create_rdf) # Update the rdf
        active_sources(:multirel).my_rdf
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
    
    def test_rel_remove
      src = ActiveSource.new('http://as_test/rel_remover')
      src[N::RDF.rew] << 'value'
      src.save!
      # Test that there is 1 element now
      assert_equal(1, (vals = SemanticRelation.find(:all, :conditions => {'subject_id' => src.id })).size, "Expected 1 value, got [#{print_rels(vals)}]")
      assert_equal(1, src.semantic_relations.size)
      # Test if the element can be removed
      src[N::RDF.rew].remove
      assert_equal(0, (vals = SemanticRelation.find(:all, :conditions => {'subject_id' => src.id })).size, "Expected 0 values, got [#{print_rels(vals)}]")
      assert_equal(0, src[N::RDF.rew].size)
    end
    
    def test_rdf_remove
      src = ActiveSource.new('http://as_test/rdf_remove')
      src[N::RDF.rew] << 'value'
      src.save!
      assert_equal(1, src.my_rdf[N::RDF.rew].size)
      src[N::RDF.rew].remove
      src.save!
      assert_equal(0, src.my_rdf[N::RDF.rew].size)
    end
    
    def test_rdf_rewrite
      src = ActiveSource.new('http://as_test/rdf_rewrite')
      src[N::RDF.rew] << 'value'
      src.save!
      src.save!
      assert_equal(1, src.my_rdf[N::RDF.rew].size)
      src[N::RDF.rew].remove
      src[N::RDF.rew] << 'new value'
      assert(1, src[N::RDF.rew].size)
      src.save!
      assert_equal(1, src.my_rdf[N::RDF.rew].size)
    end
    
    protected
    
    def print_rels(relations)
      relations.collect { |relation| "<#{relation.subject.uri} - #{relation.predicate_uri} - #{relation.object.is_a?(ActiveSource) ? relation.object.uri : relation.object.value}> | " }
    end
    
  end
end
