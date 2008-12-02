require 'test/unit'
require 'rexml/document'


# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class ImporterTest < Test::Unit::TestCase

    include UtilTestMethods

    suppress_fixtures

    # Flush RDF before each test
    def setup
      flush_once_for_import_test
      setup_once(:importer) { HyperImporter::Importer.new(load_doc('igerike-907').root) }
    end

    def test_quick_add_value
      src = TaliaCore::Source.new('http://importer-test.com/test_quick_write_value')
      @importer.send(:quick_add_predicate, src, N::RDF.something, 'value for something')
      src.save!
      assert_property(src.rdf::something, 'value for something')
      assert_equal(['value for something'],src.my_rdf[N::RDF.something])
    end

    def test_quick_add_relation
      src = TaliaCore::Source.new('http://importer-test.com/test_quick_write_relation')
      target = TaliaCore::Source.new('http://importer-test.com/test_quick_write_target')
      target.save!
      @importer.send(:quick_add_predicate, src, N::RDF.something, target)
      src.save!
      assert_property(src.rdf::something, target)
      assert_equal([target],src.my_rdf[N::RDF.something])
    end

  end
end
