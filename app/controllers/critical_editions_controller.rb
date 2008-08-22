class CriticalEditionsController < ApplicationController
  before_filter :find_critical_edition
  
  # GET /critical_editions/1
  def show  
  end
   
  # GET /critical_editions/1/1
  def book
    @book = TaliaCore::Book.find(request.url)
  end
  
  #GET /critical_editions/1/1-I
  def chapter
    @chapter = TaliaCore::Chapter.find(request.url)
    @book = @chapter.book
  end
  
  def test
    chapter = TaliaCore::Chapter.find(@critical_edition.uri.to_s + "/DD-I")
    @out = chapter.subparts_with_manifestations(N::TALIA.HyperEdition) 
  end

  private
  def find_critical_edition
    edition = "#{N::LOCAL}#{TaliaCore::CriticalEdition::EDITION_PREFIX}/#{params[:id]}"
    @critical_edition = TaliaCore::CriticalEdition.find(edition)
  end
end
 
 