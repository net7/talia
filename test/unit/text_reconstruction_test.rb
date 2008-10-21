  require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class TextReconstructionTest < Test::Unit::TestCase
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
      assert_not_nil(text_reconstruction = make_text_reconstruction('test_can_create'))
      assert(Source.exists?(text_reconstruction.uri))
    end    

    def test_hnml_transformation
      text_reconstruction = make_text_reconstruction('test_hnml_transformation')
      file_url = 'test/fixtures/hyper_editions_test_data/text_reconstruction_test_data/hnml.xml'
      data_obj = TaliaCore::DataTypes::XmlData.new
      data_obj.create_from_file('hnml.xml', file_url)
      text_reconstruction.data_records << data_obj
      text_reconstruction.dcns::format << 'application/xml+hnml'
      text_reconstruction.save!
      assert_not_nil(text_reconstruction.to_html)
    end
    
    def test_tei_transformation
      text_reconstruction = make_text_reconstruction('test_tei_transformation')
      file_url = 'test/fixtures/hyper_editions_test_data/text_reconstruction_test_data/tei.xml'
      data_obj = TaliaCore::DataTypes::XmlData.new
      data_obj.create_from_file('tei.xml', file_url)
      text_reconstruction.data_records << data_obj
      text_reconstruction.dcns::format<< 'application/xml+tei'
      text_reconstruction.save!
      assert_not_nil(text_reconstruction.to_html)
    end
  end
end
