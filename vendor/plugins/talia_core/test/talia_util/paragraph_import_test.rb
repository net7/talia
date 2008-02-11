require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class ParagraphImportTest < Test::Unit::TestCase
  
    # Establish the database connection for the test
    TaliaCore::TestHelper.startup
    
    
    # Flush RDF before each test
    def setup
      TaliaCore::TestHelper.flush_rdf
      TaliaCore::TestHelper.flush_db
    end
    
    # Test if the import succeeds
    def test_import
      src = HyperImporter::Importer.import(UtilHelper.load_doc('paragraph'))
      assert_kind_of(TaliaCore::Source, src)
    end
    
    # Test if the types were imported correctly
    def test_types
      src = HyperImporter::Importer.import(UtilHelper.load_doc('paragraph'))
      assert_kind_of(TaliaCore::Source, src)
      assert_equal(2, src.types.size)
      assert(src.types[0] == N::HYPER + "Paragraph" || src.types[0] == N::HYPER + "Work")
      assert(src.types[1] == N::HYPER + "Paragraph" || src.types[1] == N::HYPER + "Work")
      assert_not_equal(src.types[0], src.types[1])
    end
    
    # Test source name
    def test_name
      src = HyperImporter::Importer.import(UtilHelper.load_doc('paragraph'))
      assert_equal(N::LOCAL + "AC-17", src.uri)
    end
    
    # Test the manuscript paragraph
    def test_manuscript_para_title
      src = HyperImporter::Importer.import(UtilHelper.load_doc('manuscript_paragraph_coords'))
      assert_equal("D 12,10r[1]", src.dcns::title[0])
    end
    
    # Test the note import for a paragraph
    def test_paragraph_notes
      src = HyperImporter::Importer.import(UtilHelper.load_doc('manuscript_paragraph_coords'))
      notes = src.hyper::note
      assert_equal(1, notes.size)
    end
    
    # Test if the properties of a paragraph were imported correctly
    def test_paragraph_notes_position
      src = HyperImporter::Importer.import(UtilHelper.load_doc('manuscript_paragraph_coords'))
      note = src.hyper::note[0]
      assert_equal(1, note.hyper::position.size)
      assert_equal("1", note.hyper::position[0])
    end
    
    
    # Test if the properties of a paragraph were imported correctly
    def test_paragraph_notes_page
      src = HyperImporter::Importer.import(UtilHelper.load_doc('paragraph'))
      note = src.hyper::note[0]
      assert_equal(1, note.hyper::page.size)
      assert_equal("AC,[Text]", note.hyper::page[0].uri.local_name)
    end
    
    # Test import of a paragraph with multiple notes
    def test_paragraph_multiple_notes
      src = HyperImporter::Importer.import(UtilHelper.load_doc('paragraph_multinotes'))
      notes = src.hyper::note
      assert_equal(2, notes.size)
      # Some little sanity checks
      assert_equal(1, notes[0].hyper::page.size)
      assert_equal(1, notes[1].hyper::page.size)
      assert_not_equal(notes[0].hyper::page[0], notes[1].hyper::page[0])
    end
    
  end
end
