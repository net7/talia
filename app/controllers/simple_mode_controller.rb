class SimpleModeController < ApplicationController
  include TaliaCore
  
  
  def facsimile_edition_creation
    #just a reference for the creation of a Facsimile Edition
    
    #creation
    @mc = Macrocontribution.new('DEF')
    #addition of the "title" data
    @mc.predicate_set(:hyper, "title", "D'Iorio Facsimile Edition")
    #addition of the editor's notes' (used in the fe_type_list page)
    @mc.predicate_set(:hyper, 'editorsNotes', 'Description text of this Facsimile Edition, written by the author')
    #set of the macrocontribution type. Other possible types will be 'Critical', 'Genetical', 'GodKnows'
    @mc.predicate_set(:hyper, "macrocontributionType", 'Facsimile')
    @mc.save!
    
    #addition of some sources to the Macrocontribution
    @mc.add_source("egrepalysviola-1807")
    @mc.add_source("egrepalysviola-1805")
    @mc.add_source("egrepalysviola-1831")
    
  end
  
  
  # facsimile edition start page, listing material types (manuscripts, works, ...)
  def fe_type_list

    @mc_uri = params[:mc_uri]    
    @mc = Macrocontribution.new(@mc_uri)
    @mc_title = @mc.hyper::title
    @editors_notes = @mc.hyper::editorsNotes
    
    @path = [{:text => @mc_uri}]
    @displayButtons = false
        
    @page_title = "#{TaliaCore::SITE_NAME} - #{@mc_title}"
    @tabs_elements = [
      {:text => "Editor's Introduction".t, :selected => true}
    ]
    
    @types = @mc.related_types
    
    render :template => "simple_mode/facsimile_edition/type_list", :layout => "facsimile_edition"
    
  end
  
  # facsimile edition page showing the list of materials (books) of the chosen type (manuscripts, works, ...)
  def fe_material_list

    @mc_uri = params[:mc_uri]    
    @mc = Macrocontribution.new(@mc_uri)
    @mc_title = @mc.hyper::title
    @type = params[:type]
    @subtype = params[:subtype] || 'notebooks' #todo retrieve default from available list
    
    @page_title = "#{TaliaCore::SITE_NAME} - #{@mc_title}, #{@type.capitalize}"

    @path = [
      {:text => @mc_uri, :controller => 'simple_mode', :action => 'fe_type_list', :mc_uri => @mc_uri},
      {:text => @type.capitalize.t}
    ]
    
    @displayButtons = false
  
    @subtypes = @mc.related_subtypes(@type)
    
    @tabs_elements = []
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
    @mc = Macrocontribution.new(@mc_uri)
    @mc_title = @mc.hyper::title
    @material  = params[:material]
    @type = params[:type]
     
    @page_title = "#{TaliaCore::SITE_NAME} - #{@mc_title}, #{@material}"
    
    @path = [
      {:text => @mc_uri, :controller => 'simple_mode', :action => 'fe_type_list', :mc_uri => @mc_uri},
      {:text => @type.capitalize.t, :controller => 'simple_mode', :action => 'fe_material_list', :mc_uri => @mc_uri, :type => @type},
      {:text => @material}
    ]
    @displayButtons = true
    
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
    @mc = Macrocontribution.new(@mc_uri)
    @mc_title = @mc.hyper::title
    @material  = params[:material]
    @type = params[:type]
    @page = params[:page]
  
    @page_title = "#{TaliaCore::SITE_NAME} - #{@mc_title}, #{@page}"
      
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
  
  
end
