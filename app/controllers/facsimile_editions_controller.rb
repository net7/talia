class FacsimileEditionsController < ApplicationController
  include TaliaCore
  
  
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
  
  
  # facsimile edition start page, listing material types (manuscripts, works, ...)
  def fe_type_list

    @mc_uri = params[:mc_uri]    
    @mc = FacsimileEdition.new(@mc_uri)
    @mc_title = @mc.title
    @editors_notes = @mc.editors_notes
    
    #to be used by the simple_mode_path_widget
    @path = [{:text => @mc_uri}]
    @displayButtons = false
        
    @page_title = "#{TaliaCore::SITE_NAME} - #{@mc_title}"
    #to be used by the simple_mode_tabs_widget
    @tabs_elements = [
      {:text => "Editor's Introduction".t, :selected => true}
    ]
    
    @types = @mc.related_types
    
    render :template => "simple_mode/facsimile_edition/type_list", :layout => "facsimile_edition"
    
  end
  
  # facsimile edition page showing the list of materials (books) of the chosen type (manuscripts, works, ...)
  def fe_material_list

    @mc_uri = params[:mc_uri]    
    @mc = FacsimileEdition.new(@mc_uri)
    @mc_title = @mc.title
    @type = params[:type]
    
    @page_title = "#{TaliaCore::SITE_NAME} - #{@mc_title}, #{@type.capitalize}"
    #to be used by the simple_mode_path_widget
    @path = [
      {:text => @mc_uri, :controller => 'simple_mode', :action => 'fe_type_list', :mc_uri => @mc_uri},
      {:text => @type.capitalize.t}
    ]
    
    @displayButtons = false
  
    @tabs_elements = []
    
    @subtypes = @mc.related_subtypes(@type)
    @subtype = params[:subtype] || @subtypes[0] #TODO: retrieve default from available list
    
    #to be used by the simple_mode_tabs_widget
    @subtypes.each do |subtype|
      @tabs_elements << {:link => "fe_material_list?mc_uri=#{@mc_uri}&type=#{@type}&subtype=#{subtype}", :text => subtype.t, :selected => (subtype == @subtype ? true : false)}
    end
    
    @books = @mc.related_primary_sources(@type, @subtype)
    
    @elements = []
    @books.each do |book|
      @elements << {:siglum => book, :description => @mc.material_description(book), :file_path => @mc.small_image_url(book)}
    end
    
      
    render :template => "simple_mode/facsimile_edition/material_list", :layout => "facsimile_edition"
    
  end
  
  # facsimile edition page showing all the pages of a book, using small images
  def fe_panorama
    
    @mc_uri = params[:mc_uri]    
    @mc = FacsimileEdition.new(@mc_uri)
    @mc_title = @mc.title
    @material  = params[:material]
    @type = params[:type]
     
    @page_title = "#{TaliaCore::SITE_NAME} - #{@mc_title}, #{@material}"
    #to be used by the simple_mode_path_widget
    @path = [
      {:text => @mc_uri, :controller => 'simple_mode', :action => 'fe_type_list', :mc_uri => @mc_uri},
      {:text => @type.capitalize.t, :controller => 'simple_mode', :action => 'fe_material_list', :mc_uri => @mc_uri, :type => @type},
      {:text => @material}
    ]
    @displayButtons = true
    #to be used by the simple_mode_tabs_widget
    @tabs_elements = [
      {:link =>"",:text => @material, :selected => true}
    ]

    @material_description = @mc.material_description(@material)
    
    
    @elements = []
    @mc.related_pages(@material).each do |siglum|
 
      file_path = @mc.small_image_url(siglum)      
      @elements << {:siglum => siglum, :file_path => file_path}     
    end
    
    render :template => "simple_mode/facsimile_edition/panorama", :layout => "facsimile_edition"
   
  end
  
  
  # facsimile edition page showing the large image of a single facsimile 

  def fe_single_page_view

    @mc_uri = params[:mc_uri]    
    @mc = FacsimileEdition.new(@mc_uri)
    @mc_title = @mc.title
    @material  = params[:material]
    @type = params[:type]
    @page = params[:page]
  
    @page_title = "#{TaliaCore::SITE_NAME} - #{@mc_title}, #{@page}"
    #to be used by the simple_mode_path_widget
    @path = [
      {:text => @mc_uri, :controller => 'simple_mode', :action => 'fe_type_list'},
      {:text => @type.capitalize.t, :controller => 'simple_mode', :action => 'fe_material_list', :mc_uri => @mc_uri, :type => @type},
      {:text => @material, :controller => 'simple_mode', :action => 'fe_panorama', :mc_uri => @mc_uri, :type => @type, :material => @material},
      {:text => @page}
    ]
    
    @displayButtons = true

    @material_description = @mc.material_description(@material)
    
    @elements = []
    @mc.related_pages(@material).each do |siglum|
 
      file_path = @mc.small_image_url(siglum)      
      @elements << {:siglum => siglum, :file_path => file_path}     
    end
    render :template => "simple_mode/facsimile_edition/single_page_view", :layout => "facsimile_edition"
   
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
  
  
end
