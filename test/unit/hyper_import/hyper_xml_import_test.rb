require 'test/unit'
require 'rexml/document'


# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class HyperXmlImportTest < Test::Unit::TestCase
  
    include UtilTestMethods
    
    suppress_fixtures
    
    # Flush RDF before each test
    def setup
      setup_once(:flush) do
        clean_data_files
        puts "CLEANSED"
        Util.flush_rdf
        Util.flush_db
        true
      end
      setup_once(:src) do
        base_uri = File.join(File.expand_path(File.dirname(__FILE__)), "import_samples#{File::SEPARATOR}")
        list_path = "list.xml"
        sig_path = ""
        
        run_in_data_dir { HyperXmlImport.import(base_uri, list_path, sig_path) }
        true
      end
    end
    
    def test_book_exists
      assert(TaliaCore::Source.exists?(N::LOCAL + "Mp-XIV-2"))
    end
    
    def test_chapter_exists
      assert(TaliaCore::Source.exists?(N::LOCAL + "AC-[Text]"))
    end
    
    def test_edition_exists
      assert(TaliaCore::Source.exists?(N::LOCAL + "kbrunkhorst-93"))
    end
    
    def test_essay_exists
      assert(TaliaCore::Source.exists?(N::LOCAL + "jgrzelczyk-4"))
    end
    
    def test_facsimile_exists
      assert(TaliaCore::Source.exists?(N::LOCAL + "egrepalysviola-3259"))
    end
    
    def test_page_exists
      assert(TaliaCore::Source.exists?(N::LOCAL + "AC,1"))
    end
    
    def test_paragraph_exists
      assert(TaliaCore::Source.exists?(N::LOCAL + "AC-17"))
    end
    
    def test_transcription_exists
      assert(TaliaCore::Source.exists?(N::LOCAL + "igerikevzapf-539"))
    end
    
    def test_external_object_exists
      assert(TaliaCore::Source.exists?(N::LOCAL + "mmontinari-zvlbn-1987"))
    end
    
    def test_path_step_exists
      assert(TaliaCore::Source.exists?(N::LOCAL + "igerike-927,1"))
    end
    
    def test_path_exists
      assert(TaliaCore::Source.exists?(N::LOCAL + "igerike-907"))
    end
    
    def test_archive_exists
      assert(TaliaCore::Source.exists?(N::LOCAL + "Goethe-+und+Schiller-Archiv"))
    end
    
  end
end
