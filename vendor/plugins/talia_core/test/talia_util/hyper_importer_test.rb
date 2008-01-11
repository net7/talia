require 'test/unit'
require 'rexml/document'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'test_helper')

# require util stuff
require 'talia_util'



module TaliaUtil

  # Test te DataRecord storage class
  class HyperImporterTest < Test::Unit::TestCase
  
    # Establish the database connection for the test
    TaliaCore::TestHelper.startup
    TaliaCore::TestHelper.flush_db
    TaliaCore::TestHelper.flush_rdf
    
    
    # XML String for paragraph test
    PARAGRAPH_XML = "<paragraph><siglum>AC-17</siglum><title>AC-17</title><type>work_page_annotation</type><notes><note><page>AC,[Text]</page><position>17</position><coordinates/></note></notes></paragraph>"
    
    # Test the paragraph import
    def test_paragraph
      doc = REXML::Document.new(PARAGRAPH_XML)
      src = HyperImporter::Importer.import(doc)
      assert_equal(1, src.types.size)
      assert_equal(src.types[0], (N::HY_NIETZSCHE + "work_page_annotation"))
      assert_nil(src.title[0], "AC-17")
    end
    
    # Test the note import for a paragraph
    def test_paragraph_notes
      puts "**** FEATURE NOT YET IMPLEMENTED: Notes for paragraphs"
    end
  end
end
