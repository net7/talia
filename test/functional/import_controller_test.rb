require File.dirname(__FILE__) + '/fabrica_test_helper'

class ImportControllerTest < ActionController::TestCase
  
  def test_should_create_manuscript
    clean_import_cache
    authorize_as :hyper
    assert_difference "TaliaCore::Book.count", 1 do
      post :create, :document => document('export')
      assert_response :created
      # TODO restore the following assertion when the test suite will work again.
      # assert_equal "/documents/???", @response[:location]
      assert_kind_of TaliaCore::Source, assigns(:document)  
    end
  end

  def test_import_page_with_catalog
    authorize_as :hyper
    assert_difference "TaliaCore::Page.count", 2 do
      post :create, :document => document('export_KGW-AC,1_page_with_catalog') 
      assert_response :created
      assert_kind_of TaliaCore::Page, assigns(:document)
      original_page = TaliaCore::Page.find(N::LOCAL + 'AC,1')
      cloned_page = TaliaCore::Page.find(N::LOCAL + 'KGW/AC,1')
      assert_equal(N::LOCAL + 'KGW/AC', cloned_page.book.uri)
      assert_equal(N::LOCAL + 'KGW', cloned_page.catalog.uri)
      assert_equal(original_page::hyper.primary_source, cloned_page::hyper.primary_source)
    end
  end
  
  
  def test_import_chapter_with_catalog
    authorize_as :hyper
    assert_difference "TaliaCore::Chapter.count", 2 do
      post :create, :document => document('export_KGW-AC-[Text]_chapter_with_catalog') 
      assert_response :created
      assert_kind_of TaliaCore::Chapter, assigns(:document)
      cloned_chapter = TaliaCore::Chapter.find(N::LOCAL + 'KGW/AC-[Text]')
      assert_equal(N::LOCAL + 'KGW/AC,[Text]', cloned_chapter.first_page.uri)
      assert_equal(N::LOCAL + 'KGW/AC', cloned_chapter.book.uri)
    end
  end
  

  def test_import_paragraph_with_catalog
    authorize_as :hyper
    assert_difference "TaliaCore::Paragraph.count", 2 do
      post :create, :document => document('export_KGW-AC-17_paragraph_with_catalog') 
      assert_response :created
      assert_kind_of TaliaCore::Paragraph, assigns(:document)
      cloned_paragraph = TaliaCore::Paragraph.find(N::LOCAL + 'KGW/AC-17')
      assert_equal(N::LOCAL + 'KGW/AC-17', cloned_paragraph.uri)
      assert_equal(N::LOCAL + 'KGW/AC-17-note17', cloned_paragraph.notes[0].uri)
      assert_equal(N::LOCAL + 'KGW/AC,[Text]', cloned_paragraph.pages[0].uri)
      assert_equal(N::LOCAL + 'KGW', cloned_paragraph.catalog.uri)
    end
  end

 
  def test_import_book_with_catalog
    authorize_as :hyper
    assert_difference "TaliaCore::Book.count", 2 do
      post :create, :document => document('export_KGW-AC_book_with_catalog')
      assert_response :created
      cloned_book = TaliaCore::Source.find(N::LOCAL + 'KGW/KGW-AC')
      assert_equal(N::LOCAL + 'KGW', cloned_book.catalog.uri)
    end
  end
  
  def test_import_page
    authorize_as :hyper
    assert_difference "TaliaCore::Page.count", 1 do
      post :create, :document => document('export5') # imports the D-11,101v page
      assert_response :created
      assert_kind_of TaliaCore::Page, assigns(:document)
    end
  end
  
  
  def test_should_return_client_error_on_nil_document
    authorize_as :hyper
    assert_no_difference "TaliaCore::Source.count" do
      post :create, :document => nil
      assert_response :unprocessable_entity      
    end
  end
  
  def test_should_return_client_error_on_empty_document
    authorize_as :hyper
    assert_no_difference "TaliaCore::Source.count" do
      post :create, :document => ''
      assert_response :unprocessable_entity      
    end
  end
  
  def test_should_return_client_error_on_malformed_document
    authorize_as :hyper
    assert_no_difference "TaliaCore::Source.count" do
      post :create, :document => 'book'
      assert_response :unprocessable_entity      
    end
  end
  
  def test_should_redirect_to_login_path_on_missing_authorization
    post :create, :document => document('export')
    assert_redirected_to login_path
  end
end
