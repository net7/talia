# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

module TaliaCore

  # Test the ActiveSource
  class OrderedSourceTest < Test::Unit::TestCase

    #    fixtures :active_sources, :semantic_properties, :semantic_relations

    def setup
      setup_once(:flush) do
        TaliaUtil::Util.flush_db
        TaliaUtil::Util.flush_rdf
        true
      end

      setup_once(:fat_object_item) do
        attributes = {
          'id' => 1,
          'created_at' => '2009-02-27 00:00:01',
          'updated_at' => '2009-02-27 00:00:02',
          'object_id' => 23,
          'object_type' => 'TaliaCore::ActiveSource',
          'subject_id' => 17,
          'predicate_uri' => 'http://testpred.org/test',
          'property_created_at' => nil,
          'property_updated_at' => nil,
          'property_value' => nil,
          'object_created_at' => '2009-02-27 00:00:03',
          'object_updated_at' => '2009-02-27 00:00:04',
          'object_realtype' => 'Source',
          'object_uri' => 'http://myobject/uri',
        }
        fat_rel = SemanticRelation.send(:instantiate, attributes)
        item = SemanticCollectionItem.new(fat_rel, :fat)
        item
      end

      setup_once(:fat_property_item) do
        attributes = {
          'id' => 1,
          'created_at' => '2009-02-27 00:00:01',
          'updated_at' => '2009-02-27 00:00:02',
          'object_id' => 24,
          'object_type' => 'TaliaCore::SemanticProperty',
          'subject_id' => 17,
          'predicate_uri' => 'http://testpred.org/test',
          'property_created_at' => '2009-02-27 00:00:05',
          'property_updated_at' => '2009-02-27 00:00:06',
          'property_value' => 'test value',
          'object_created_at' => nil,
          'object_updated_at' => nil,
          'object_realtype' => nil,
          'object_uri' => nil,
        }
        fat_rel = SemanticRelation.send(:instantiate, attributes)
        item = SemanticCollectionItem.new(fat_rel, :fat)
        item
      end
    end

    def test_object_id
      assert_equal(23, @fat_object_item.object.id)
    end

    def test_object_created
      assert_equal(Time.parse('2009-02-27 00:00:03'), @fat_object_item.object.created_at)
    end

    def test_object_updated
      assert_equal(Time.parse('2009-02-27 00:00:04'), @fat_object_item.object.updated_at)
    end

    def test_object_type
      assert_kind_of(Source, @fat_object_item.object)
    end
    
    def test_object_uri
      assert_equal(N::URI.new('http://myobject/uri'), @fat_object_item.object.uri)
    end

    def test_property_id
      assert_equal(24, @fat_property_item.object.id)
    end

    def test_property_created
      assert_equal(Time.parse('2009-02-27 00:00:05'), @fat_property_item.object.created_at)
    end

    def test_property_updated
      assert_equal(Time.parse('2009-02-27 00:00:06'), @fat_property_item.object.updated_at)
    end

    def test_property_class
      assert_kind_of(SemanticProperty, @fat_property_item.object)
    end

    def test_property_value
      assert_equal('test value', @fat_property_item.object.value)
    end

    def test_value
      assert_equal(@fat_property_item.object.value, @fat_property_item.value)
      assert_equal(@fat_object_item.object, @fat_object_item.value)
    end

    def test_value_typed
      @fat_object_item.instance_variable_set(:@object_type, N::URI)
      assert_kind_of(N::URI, @fat_object_item.value)
      @fat_object_item.instance_variable_set(:@object_type, nil)
    end

    def test_prop_type_err
      @fat_property_item.instance_variable_set(:@object_type, N::URI)
      assert_raise(ArgumentError) { @fat_property_item.value }
      @fat_property_item.instance_variable_set(:@object_type, nil)
    end

    def test_equality_value
      assert_equal(@fat_property_item, 'test value')
    end

    def test_equality_object
      assert_equal(@fat_object_item, Source.new(@fat_object_item.object.uri.to_s))
    end

  end
end
