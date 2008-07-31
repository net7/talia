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
    type = params[:subtype] || params[:type]
    @books = @facsimile_edition.books(N::LOCAL + type)    
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
        book = TaliaCore::Book.find(request.url)
        @description = book.material_description
        @pages = book.pages
        #TODO: maybe a supertype method of the "Book" class for doing:
        # book.supertype
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
        qry = Query.new(TaliaCore::Book).select(:b).distinct
        qry.where(:p, N::HYPER.is_part_of, :b)
        qry.where(:p, N::HYPER.siglum, params[:page])
        result=qry.execute
        book = result[0]
        @description = book.material_description
        @pages = book.pages
        #TODO: retrieve these data from somewhere, maybe a "Page" class is required
        # @type = TaliaCore::Page.find(request.url).supertype
        @type = 'manuscripts'
      end
      format.jpeg do
        facsimile = TaliaCore::Page.find(request.url).manifestations(TaliaCore::Facsimile)
        facsimile.iip_path
        #TODO: as soon as the iip_path method is ready, implement the missing part here
        # and/or in the view which uses this (namely the panorama widget and the page and 
        # the facing_pages views)
        # 
        # here as a reference what used to be done here, when the image was supposed to be
        # taken from the DB
        #        image = @facsimile_edition.page_image_data(params[:book], params[:page], params[:size]) 
        #        send_data image.content_string, :type => 'image/jpeg', :disposition => 'inline' 
      end
    end
  end

  # facsimile edition page showing two large images of two adjacent pages
  def facing_pages
    qry = Query.new(TaliaCore::Book).select(:b).distinct
    qry.where(:p, N::HYPER.is_part_of, :b)
    qry.where(:p, N::HYPER.siglum, params[:page])
    book = qry.execute[0]
    @description = book.material_description
    @pages = book.pages
    @page1 = params[:page]
    @page2 = params[:page2]
    
    #TODO: retrieve these data from somewhere, maybe a "Page" class is required
    # @type = TaliaCore::Page.find(??).supertype
    @type = 'manuscripts'
  end
  
  def search 
    searched_book = sanitize(params[:book]) unless params[:book].empty?
    searched_page = sanitize(params[:page]) unless params[:page].empty?
    search_result = @facsimile_edition.search(searched_book, searched_page)
    url = "/#{TaliaCore::FACSIMILE_EDITION_PREFIX}/#{params[:id]}" 
    search_result.each do |part|
      url << "/#{part}"
    end
    redirect_to url and return unless (search_result.empty?)
    flash[:search_notice] = "Searched records weren't found".t
    redirect_to(:back) and return
  end
  
  private
  def find_facsimile_edition
    @facsimile_edition = TaliaCore::FacsimileEdition.find("#{N::LOCAL}#{params[:id]}")
  end
end
