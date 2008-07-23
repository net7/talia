class FacsimileEditionsController < ApplicationController
  before_filter :find_facsimile_edition
 
  # GET /facsimile_editions/1
  def show
  end

  # GET /facsimile_editions/1/works
  # GET /facsimile_editions/1/manuscripts
  # GET /facsimile_editions/1/library
  # GET /facsimile_editions/1/correspondence
  # GET /facsimile_editions/1/pictures
  #
  # GET /facsimile_editions/1/manuscripts/copybooks
  def books
    @books = @facsimile_edition.books(params[:type], params[:subtype])    
    @type = params[:type]
    @subtype = params[:subtype]
  end
  
  # GET /facsimile_editions/1/1
  # 
  # GET /facsimile_editions/1/1.jpeg
  # GET /facsimile_editions/1/1.jpeg?size=thumbnail
   
  def panorama
    respond_to do |format|
      format.html do
        @description = @facsimile_edition.material_description(params[:id])
        @pages = @facsimile_edition.related_pages(params[:id])
        #TODO: maybe a "Book" class for things like the following:
        # @type = TaliaCore::Book.find(params[:id]).supertype
        @type = 'manuscripts'
        
      end
      format.jpeg do
        image = @facsimile_edition.book_image_data(params[:book], params[:size]) 
        send_data image.content_string, :type => 'image/jpeg', :disposition => 'inline'
      end
    end
  end
    
  # TODO DRYup w/ panorama
  # GET /facsimile_editions/1/1,1
  # 
  # GET /facsimile_editions/1/1,1.jpeg
  # GET /facsimile_editions/1/1,1.jpeg?size=thumbnail
  def page
    respond_to do |format|
      format.html do
        @description = @facsimile_edition.material_description(params[:id])
        @pages = @facsimile_edition.related_pages(params[:id])
        #TODO: retrieve these data from somewhere, maybe a "Page" class is required
        # @type = TaliaCore::Page.find(params[:page]).supertype
        @type = 'manuscripts'
      end
      format.jpeg do
        image = @facsimile_edition.page_image_data(params[:book], params[:page], params[:size]) 
        send_data image.content_string, :type => 'image/jpeg', :disposition => 'inline' 
      end
    end
  end

  # facsimile edition page showing two large images of two adjacent pages
  def facing_pages
    @description = @facsimile_edition.material_description(params[:id])
    @pages = @facsimile_edition.related_pages(params[:id])
    @page1 = params[:page]
    @page2 = params[:page2]
    #TODO: retrieve these data from somewhere, maybe a "Page" class is required
    # @type = TaliaCore::Page.find(params[:page]).supertype
    @type = 'manuscripts'
  end
  
  def search 
    searched_book = sanitize(params[:book])
    searched_page = sanitize(params[:page])
    search_result = @facsimile_edition.search(searched_book, searched_page)
    url = "/#{TaliaCore::FACSIMILE_EDITION_PREFIX}/#{params[:id]}" 
    search_result.each do |part|
      url << "/#{part}"
    end
    redirect_to url and return
  rescue ActiveRecord::RecordNotFound
    flash[:search_notice] = "Searched records weren't found".t
    redirect_to(:back)
  end
  
  private
  def find_facsimile_edition
    @facsimile_edition = TaliaCore::FacsimileEdition.find("#{N::LOCAL}#{params[:id]}")
  end
end
