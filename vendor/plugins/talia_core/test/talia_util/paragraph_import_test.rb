require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class ParagraphImportTest < Test::Unit::TestCase
  
    include UtilTestMethods
    
    # Establish the database connection for the test
    TaliaCore::TestHelper.startup
    
    
    # Flush RDF before each test
    def setup
      setup_once(:flush) do
        clean_data_files
        TaliaCore::TestHelper.flush_rdf
        TaliaCore::TestHelper.flush_db
      end
      
      setup_once(:paragraph) { HyperImporter::Importer.import(load_doc('AC-17')) }
      setup_once(:coord_para) { HyperImporter::Importer.import(load_doc('D-12,10r[1]')) }
      setup_once(:multinotes) { HyperImporter::Importer.import(load_doc('Mp-XIV-2,55v[2]et56r[1]')) }
      setup_once(:work_para) { HyperImporter::Importer.import(load_doc('WS-194')) }
    
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::Source, @paragraph)
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_types(@paragraph, N::HYPER + "Paragraph", N::HYPER + "Work")
    end
    
    # Test source name
    def test_name
      assert_equal(N::LOCAL + "AC-17", @paragraph.uri)
    end
    
    # Test the manuscript paragraph
    def test_manuscript_para_title
      assert_property(@coord_para.dcns::title, "D 12,10r[1]")
    end
    
    # Test the note import for a paragraph
    def test_paragraph_notes
      notes = @coord_para.hyper::note
      assert_equal(1, notes.size)
    end
    
    # Test if the properties of a paragraph were imported correctly
    def test_paragraph_notes_position
      note = @coord_para.hyper::note[0]
      assert_property(note.hyper::position, "1")
    end
    
    
    # Test if the properties of a paragraph were imported correctly
    def test_paragraph_notes_page
      note = @paragraph.hyper::note[0]
      assert_property(note.hyper::page, N::LOCAL + "AC,[Text]")
    end
    
    # Test import of a paragraph with multiple notes
    def test_paragraph_multiple_notes
      notes = @multinotes.hyper::note
      assert_equal(2, notes.size)
      # Some little sanity checks
      assert_equal(1, notes[0].hyper::page.size)
      assert_equal(1, notes[1].hyper::page.size)
      assert_not_equal(notes[0].hyper::page[0], notes[1].hyper::page[0])
    end
    
    # Test work paragraph
    def test_work_paragrahph
      assert_types(@work_para, N::HYPER + "Paragraph", N::HYPER + "Work")
      assert_equal(2, @work_para.hyper::note.size)
    end
    
  end
end
