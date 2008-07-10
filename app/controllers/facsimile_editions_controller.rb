  class FacsimileEditionsController < ApplicationController
  include TaliaCore
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
  def panorama
    @description = @facsimile_edition.material_description(params[:id])
    @pages = @facsimile_edition.related_pages(params[:id])
    #TODO: maybe a "Book" class for things like the following:
    @type = 'manuscripts'
  end
  
  # TODO DRYup w/ panorama
  # GET /facsimile_editions/1/1,1
  def page
    @description = @facsimile_edition.material_description(params[:id])
    @pages = @facsimile_edition.related_pages(params[:id])
    #TODO: retrieve these data from somewhere, maybe a "Page" class is required
    @type = 'manuscripts'
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
  
  def facsimile_edition_creation
    #just a reference for the creation of a Facsimile Edition
      
    #creation
    @mc = FacsimileEdition.new('TEST')
    @mc.save!
        
    #addition of the "title" data
    @mc.title="TEST Facsimile Edition"
    #addition of the editor's notes' (used in the fe_type_list page)
    @mc.editors_notes="Description text of this Facsimile Edition, written by the author"

    
    #addition of some sources to the Macrocontribution
    @mc.add_source("egrepalysviola-1807")
    @mc.add_source("egrepalysviola-1805")
    @mc.add_source("egrepalysviola-1831")
    

    render :template => "simple_mode/facsimile_edition/test"  
  end
  
  private
    def find_facsimile_edition
      @facsimile_edition = FacsimileEdition.find(params[:id])
    end
end
