class CriticalEditionsController < ApplicationController
  before_filter :find_critical_edition
  
  # GET /critical_editions/1
  def show  
    #TODO: load all the books and create the left menu
    # the right zone of the web page will contain the description/some info
    @menu_items = []
    @books = @critical_edition.books
    @books.each do |book|
      @menu_items << {:uri => book, :title => TaliaCore.Book.find(book).dcns::title}
    end
  end
  
  private
  def find_critical_edition
    @critical_edition = TaliaCore::CriticalEdition.find("#{N::LOCAL}#{params[:id]}")
  end
end
 
 