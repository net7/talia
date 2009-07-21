# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore

  # Test the ActiveSource
  class ActiveSourcePredicateTest < Test::Unit::TestCase

    def setup
      setup_once(:flush) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end

    def test_each_cached
      src = ActiveSource.new('http://pred_test/each_cached')
      src[N::RDF.rew] << 'value'
      cached = []
      src.each_cached_wrapper do |w|
        cached << w
      end
      assert_equal(2, cached.size)
    end
    
    def test_cached_predicate
      src = ActiveSource.new('http://pred_test/cached_predicate')
      src[N::RDF.rew] << 'value'
      # We assume that the cached thing is now in the internal structure
      w = src.instance_variable_get(:@type_cache)[N::RDF.rew.to_s]
      items = w.instance_variable_get(:@items)
      assert_kind_of(Array, items)
      assert_equal(['value'], items.collect { |i| i.value })
      assert_same(src[N::RDF.rew], w)
    end

    def test_cached_after_save
      src = ActiveSource.new('http://pred_test/cached_after_save')
      src[N::RDF.rew] << 'value'
      src.save!
      # We assume that the cached thing is now in the internal structure
      w = src.instance_variable_get(:@type_cache)[N::RDF.rew.to_s]
      items = w.send(:items) # This should correctly reload the items
      assert_kind_of(Array, items)
      assert_equal(['value'], items.collect { |i| i.value })
      assert_same(src[N::RDF.rew], w)
      # Check if the RDF was updated. The RDF must be updated from the cached wrappers
      # before the wrappers are saved themselves
      assert_equal(['value'], src.my_rdf[N::RDF.rew], "Mismatch of the RDF, maybe the callbacks in wrong order?")
    end

  end
end