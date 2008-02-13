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
    
    # Establish the database connection for the test
    TaliaCore::TestHelper.startup
    
    
    # Flush RDF before each test
    def setup
      setup_once(:flush) do
        clean_data_files
        TaliaCore::TestHelper.flush_rdf
        TaliaCore::TestHelper.flush_db
      end
      setup_once(:src) do
        base_uri = File.join(File.expand_path(File.dirname(__FILE__)), "import_samples#{File::SEPARATOR}")
        list_path = "test_list.xml"
        sig_path = ""
        
        HyperXmlImport.import(base_uri, list_path, sig_path)
        true
      end
    end
    
    def test_book_exists
      assert(TaliaCore::Source.exists?("Mp-XIV-2"))
    end
    
    def test_chapter_exists
      assert(TaliaCore::Source.exists?("AC-[Text]"))
    end
    
    def test_edition_exists
      assert(TaliaCore::Source.exists?("kbrunkhorst-93"))
    end
    
    def test_essay_exists
      assert(TaliaCore::Source.exists?("jgrzelczyk-4"))
    end
    
    def test_facsimile_exists
      assert(TaliaCore::Source.exists?("egrepalysviola-3259"))
    end
    
    def test_page_exists
      assert(TaliaCore::Source.exists?("AC,1"))
    end
    
    def test_paragraph_exists
      assert(TaliaCore::Source.exists?("AC-17"))
    end
    
    def test_transcription_exists
      assert(TaliaCore::Source.exists?("igerikevzapf-539"))
    end
    
  end
end
