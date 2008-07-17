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
        @type = 'manuscripts'
      end
      format.jpeg do
        image = @facsimile_edition.page_image_data(params[:book], params[:page], params[:size]) 
        send_data image.content_string, :type => 'image/jpeg', :disposition => 'inline' 
      end
    end
  end

  
  def search 
    searched_book = sanitize(params[:book])
    searched_page = sanitize(params[:page])
    search_result = @facsimile_edition.search(searched_book, searched_page)
    url = "/facsimile_editions/#{params[:id]}" 
    search_result.each do |part|
      url << "/#{part}"
    end
    redirect_to url and return
    #TODO: why this didn't work? (to be removed, left here as a reference)
    # note that this suppose that @facsimile_edition.search returns an _hash_ 
    # you'll find commented versions of returned values in there related to the
    # following line
    #        redirect_to :action => 'page', :book => search_result[:book], :page => search_result[:page], :id => params[:id] and return
    
  rescue ActiveRecord::RecordNotFound
    flash[:search_notice] = "Searched records weren't found".t
    redirect_to(:back)
  end
  
  
  # facsimile edition page showing two large images of two adjacent pages
  def fe_double_page_view
    @mc_uri = params[:mc_uri]    
    @mc = FacsimileEdition.new(@mc_uri)
    @mc_title = @mc.title
    @material  = params[:material]
    @type = params[:type]
    @page1 = params[:page1]
    @page2 = params[:page2]
    
    @page_title = "#{TaliaCore::SITE_NAME} - #{@mc_title}, #{@page1} | #{@page2}"
    #to be used by the simple_mode_path_widget
    @path = [
      {:text => @mc_uri, :controller => 'simple_mode', :action => 'fe_type_list'},
      {:text => @type.capitalize.t, :controller => 'simple_mode', :action => 'fe_material_list', :mc_uri => @mc_uri, :type => @type},
      {:text => @material, :controller => 'simple_mode', :action => 'fe_panorama', :mc_uri => @mc_uri, :type => @type, :material => @material},
      {:text => @page1 + " | " + @page2}
    ]
    
    @displayButtons = true

    @material_description = @mc.material_description(@material)
    
    @elements = []
    @mc.related_pages(@material).each do |siglum|
 
      file_path = @mc.small_image_url(siglum)      
      @elements << {:siglum => siglum, :file_path => file_path}     
    end
    render :template => "simple_mode/facsimile_edition/double_page_view", :layout => "facsimile_edition"
  end
  
  private
  def find_facsimile_edition
    @facsimile_edition = TaliaCore::FacsimileEdition.find("#{N::LOCAL}#{params[:id]}")
  end
end
