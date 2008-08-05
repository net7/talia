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
    @books = @facsimile_edition.books(type)    
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
        @book = TaliaCore::Book.find(request.url)
        @type = @book.hyper::type[0]
      end
      format.jpeg do
        #TODO: change to use the iip when it's ready
#        image = @facsimile_edition.book_image_data(params[:book], params[:size]) 
#        send_data image.content_string, :type => 'image/jpeg', :disposition => 'inline'
result = ''
      end
    end
  end
    
  # TODO DRYup w/ panorama
  # GET /facsimile_editions/1,1
  # 
  # GET /facsimile_editions/1,1.jpeg
  # GET /facsimile_editions/1,1.jpeg?size=thumbnail
  def page
    respond_to do |format|
      format.html do
        # if a 'pages' params with 'double' as a value and a 'page2' param with
        # the siglum of a page have been passed, we need to show the large images of both pages 
        if (params[:pages] == 'double')
          @page = TaliaCore::Page.find(N::LOCAL + TaliaCore::FACSIMILE_EDITION_PREFIX + '/' + params[:id] + '/' + params[:page])
          @page2 = TaliaCore::Page.find(N::LOCAL + TaliaCore::FACSIMILE_EDITION_PREFIX + '/' + params[:id] + '/' + params[:page2])
        else
          @page = TaliaCore::Page.find(request.url)
        end         
        qry = Query.new(TaliaCore::Book).select(:b).distinct
        qry.where(@page, N::HYPER.part_of, :b)
        result=qry.execute
        @book = result[0]
        @type = @book.hyper::type[0]
      end
      format.jpeg do
        facsimile = TaliaCore::Page.find(N::LOCAL + TaliaCore::FACSIMILE_EDITION_PREFIX + '/' + params[:id] + '/' + params[:page]).manifestations(TaliaCore::Facsimile)
        facsimile.iip_path
        result = ''
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

  
  def search 
    searched_book = sanitize(params[:book]) unless params[:book].empty?
    searched_page = sanitize(params[:page]) unless params[:page].empty?
    search_result = @facsimile_edition.search(searched_book, searched_page)
    redirect_to search_result[0].uri.to_s and return unless (search_result.empty?)
    flash[:search_notice] = "Searched records weren't found".t
    redirect_to(:back) and return
  end
  
  private
  def find_facsimile_edition
    @facsimile_edition = TaliaCore::FacsimileEdition.find("#{N::LOCAL}#{TaliaCore::FACSIMILE_EDITION_PREFIX}/#{params[:id]}")
  end
end
