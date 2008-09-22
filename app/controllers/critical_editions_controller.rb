class CriticalEditionsController < ApplicationController
  before_filter :find_critical_edition
  
  def dispatcher
    @source = TaliaCore::Source.find(request.url)
    case @source
    when TaliaCore::Book
      send("render_book")
    when TaliaCore::Chapter
      send("render_chapter")
    else
      send("render_part")
    end
  end
  
  # GET /critical_editions/1
  def show  
  end

  private

  def find_critical_edition
    edition = "#{N::LOCAL}#{TaliaCore::CriticalEdition::EDITION_PREFIX}/#{params[:id]}"
    @critical_edition = TaliaCore::CriticalEdition.find(edition)
  end
  
  def render_book
    @book = TaliaCore::Book.find(request.url)
    render :template => 'critical_editions/book'    
  end
  
  def render_chapter
    @chapter = TaliaCore::Chapter.find(request.url)
    @href_for_text = @chapter.subparts_with_manifestations(N::HYPER.HyperEdition)[0] 
    @book = @chapter.book
    render :template => 'critical_editions/chapter'
  end
  
  def render_part
    @part = TaliaCore::Source.find(request.url) 
    @href_for_text = request.url 
    @book = @part.book
    @chapter = @part.chapter
    render :template => 'critical_editions/part'
  end
end
 
 