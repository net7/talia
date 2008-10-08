  require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class EditionTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_can_create
      assert_not_nil(edition = make_edition('test_can_create'))
      assert(Source.exists?(edition.uri))
    end    

    def test_hnml_transformation
      edition = make_edition('test_hnml_transformation')
      file_url = 'test/fixtures/hyper_editions_test_data/edition_test_data/hnml.xml'
      data_obj = TaliaCore::DataTypes::XmlData.new
      data_obj.create_from_file('hnml.xml', file_url)
      edition.data_records << data_obj
      edition.hyper::file_content_type << 'hnml'
      edition.save!
      assert_not_nil(edition.to_html)
    end
    
    def test_tei_transformation
      edition = make_edition('test_tei_transformation')
      file_url = 'test/fixtures/hyper_editions_test_data/edition_test_data/tei.xml'
      data_obj = TaliaCore::DataTypes::XmlData.new
      data_obj.create_from_file('tei.xml', file_url)
      edition.data_records << data_obj
      edition.hyper::file_content_type << 'TEI'
      edition.save!
      assert_not_nil(edition.to_html)
    end
  end
end
