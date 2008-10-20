require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class TranscriptionTest < Test::Unit::TestCase
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
      assert_not_nil(transcription = make_transcription('test_can_create'))
      assert(Source.exists?(transcription.uri))
    end    
    
     def test_hnml_transformation
      transcription = make_transcription('test_hnml_transformation')
      file_url = 'test/fixtures/hyper_editions_test_data/transcription_test_data/hnml.xml'
      data_obj = TaliaCore::DataTypes::XmlData.new
      data_obj.create_from_file('hnml.xml', file_url)
      transcription.data_records << data_obj
      transcription.dcns::format << 'application/xml+hnml'
      transcription.save!
      assert_not_nil(transcription.to_html)
    end
    
    def test_tei_transformation
      transcription = make_transcription('test_tei_transformation')
      file_url = 'test/fixtures/hyper_editions_test_data/transcription_test_data/tei.xml'
      data_obj = TaliaCore::DataTypes::XmlData.new
      data_obj.create_from_file('tei.xml', file_url)
      transcription.data_records << data_obj
      transcription.dcns::format << 'application/xml+tei'
      transcription.save!
      assert_not_nil(transcription.to_html)
    end
  end
end
