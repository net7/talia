class SimpleModeController < ApplicationController
  include TaliaCore
  
  def test_rdf
    
    @uri = "http://www.talia.discovery-project.org/sources/FED"
    @mc = Macrocontribution.find(@uri)
    #    @primarySourceTypes = @mc.related_primary_sources()
 
    @data = @mc.inverse_predicates
    
    #@data = {}
    render :template => "simple_mode/facsimile_edition/test_rdf"
  end
  
  
  def create_mc_data
    @uris = [
      'http://www.talia.discovery-project.org/sources/egrepalysviola-95',
      'http://www.talia.discovery-project.org/sources/egrepalysviola-93',
      'http://www.talia.discovery-project.org/sources/egrepalysviola-97',
      'http://www.talia.discovery-project.org/sources/egrepalysviola-99',
      'http://www.talia.discovery-project.org/sources/egrepalysviola-91', 
    ]
    
    
    @rdf_resources = []
    @uris.each do |uri|
      source = Source.new(uri)
      @t = source.to_rdf()
      #      @rdf_resources << RdfResource.new(uri) 
      @rdf_resources << RdfResource.new(uri) 
      #Source.
    end
    
    @tmp = RdfResource.new(@uris[1])
    
    render :template => "simple_mode/facsimile_edition/create_mc_data"
    
  end
  
  def type_list

    #TODO: retrieve from DB/RDF
    @MC_title = "D'Iorio Facsimile Edition"

    
    @path = [{:text => params[:mc]}]
    @displayButtons = false
        
    @page_title = "#{TaliaCore::SITE_NAME} - #{@MC_title}"
    @tabs_elements = [
      {:text => "Editor's Introduction".t, :selected => true}
    ]
    
    @editor_text = "some text from the editor, RDF will store it"
    
    render :template => "simple_mode/facsimile_edition/index", :layout => "facsimile_edition"
    
  end
  
  def material_list

    #TODO: retrieve from DB/RDF
    @MC_title = "D'Iorio Facsimile Edition"
    @mc = params[:mc]
    @type = params[:type]
    @subtype = params[:subtype] || 'notebooks' #todo retrieve default from available list
    
    @page_title = "#{TaliaCore::SITE_NAME} - #{@MC_title}, #{@type.capitalize}"

    @path = [
      {:text => params[:mc], :controller => 'simple_mode', :action => 'type_list', :mc => @mc},
      {:text => @type.capitalize.t}
    ]
    
    @displayButtons = false
  
    #todo: retrieve subtypes from RDF
    @subtypes = ['copybooks', 'notebooks', 'drafts']
    
    @tabs_elements = []
    @subtypes.each do |subtype|
      @tabs_elements << {:link => "material_list?mc=#{params[:mc]}&type=#{@type}&subtype=#{subtype}", :text => subtype.t, :selected => (subtype == @subtype ? true : false)}
    end
    @elements = [ 
      {:siglum => 'N-IV-1', :description => 'N-IV-1 description', :file_path => ""},
      {:siglum => 'N-IV-2', :description => 'N-IV-2 description', :file_path => ""},
      {:siglum => 'N-IV-3', :description => 'N-IV-3 description', :file_path => ""},
      {:siglum => 'N-IV-4', :description => 'N-IV-4 description', :file_path => ""},
      {:siglum => 'N-IV-5', :description => 'N-IV-5 description', :file_path => ""},
      {:siglum => 'N-IV-6', :description => 'N-IV-6 description', :file_path => ""},
      {:siglum => 'N-IV-7', :description => 'N-IV-7 description', :file_path => ""},
      {:siglum => 'N-IV-8', :description => 'N-IV-8 description', :file_path => ""},
      {:siglum => 'N-IV-9', :description => 'N-IV-9 description', :file_path => ""}
    ]
    
      
    render :template => "simple_mode/facsimile_edition/material_list", :layout => "facsimile_edition"
    
  end
  
  def panorama
    
    #TODO: retrieve from DB/RDF
    @MC_title = "D'Iorio Facsimile Edition"
    @mc = params[:mc]
    @material  = params[:material]
    @type = params[:type]
    
    @page_title = "#{TaliaCore::SITE_NAME} - #{@MC_title}, #{@material}"
    
    @path = [
      {:text => @mc, :controller => 'simple_mode', :action => 'type_list', :mc => @mc},
      {:text => @type.capitalize.t, :controller => 'simple_mode', :action => 'material_list', :mc => @mc, :type => @type},
      {:text => @material}
    ]
    @displayButtons = true
    
    @tabs_elements = [
      {:link =>"",:text => @material, :selected => true}
    ]
    
    @elements = [
      {:siglum => 'N-IV-1,1', :file_path => 'imgs/N-IV-1,1.jpg'},
      {:siglum => 'N-IV-1,2', :file_path => 'imgs/N-IV-1,2.jpg'},
      {:siglum => 'N-IV-1,3', :file_path => 'imgs/N-IV-1,3.jpg'},
      {:siglum => 'N-IV-1,4', :file_path => 'imgs/N-IV-1,4.jpg'},
      {:siglum => 'N-IV-1,5', :file_path => 'imgs/N-IV-1,5.jpg'},
      {:siglum => 'N-IV-1,6', :file_path => 'imgs/N-IV-1,6.jpg'},
      {:siglum => 'N-IV-1,7', :file_path => 'imgs/N-IV-1,7.jpg'},
      {:siglum => 'N-IV-1,8', :file_path => 'imgs/N-IV-1,8.jpg'},
      {:siglum => 'N-IV-1,9', :file_path => 'imgs/N-IV-1,9.jpg'},
      {:siglum => 'N-IV-1,10', :file_path => 'imgs/N-IV-1,10.jpg'},
      {:siglum => 'N-IV-1,11', :file_path => 'imgs/N-IV-1,11.jpg'},
      {:siglum => 'N-IV-1,12', :file_path => 'imgs/N-IV-1,12.jpg'}
    ]
    
    render :template => "simple_mode/facsimile_edition/panorama", :layout => "facsimile_edition"
   
  end
  
  def single_page_view

    #TODO: retrieve from DB/RDF
    @MC_title = "D'Iorio Facsimile Edition"
    @mc = params[:mc]
    @material  = params[:material]
    @type = params[:type]
    @page = params[:page]
  
    @page_title = "#{TaliaCore::SITE_NAME} - #{@MC_title}, #{@page}"
      
    @path = [
      {:text => @mc, :controller => 'simple_mode', :action => 'type_list'},
      {:text => @type.capitalize.t, :controller => 'simple_mode', :action => 'material_list', :mc => @mc, :type => @type},
      {:text => @material, :controller => 'simple_mode', :action => 'panorama', :mc => @mc, :type => @type, :material => @material},
      {:text => @page}
    ]
    
    @displayButtons = true
    
    @elements = [
      {:file_path => "", :siglum => "N-IV-1,1"},
      {:file_path => "", :siglum => "N-IV-1,2"},
      {:file_path => "", :siglum => "N-IV-1,3"},
      {:file_path => "", :siglum => "N-IV-1,4"},
      {:file_path => "", :siglum => "N-IV-1,5"},
      {:file_path => "", :siglum => "N-IV-1,6"},
      {:file_path => "", :siglum => "N-IV-1,7"},
      {:file_path => "", :siglum => "N-IV-1,8"},
      {:file_path => "", :siglum => "N-IV-1,9"},
      {:file_path => "", :siglum => "N-IV-1,10"},
      {:file_path => "", :siglum => "N-IV-1,11"},
      {:file_path => "", :siglum => "N-IV-1,12"},
      {:file_path => "", :siglum => "N-IV-1,13"},
      {:file_path => "", :siglum => "N-IV-1,14"},
      {:file_path => "", :siglum => "N-IV-1,15"},
      {:file_path => "", :siglum => "N-IV-1,16"},
      {:file_path => "", :siglum => "N-IV-1,17"},
      {:file_path => "", :siglum => "N-IV-1,18"},
      {:file_path => "", :siglum => "N-IV-1,19"},
      {:file_path => "", :siglum => "N-IV-1,20"},
      {:file_path => "", :siglum => "N-IV-1,21"},
      {:file_path => "", :siglum => "N-IV-1,22"},
      {:file_path => "", :siglum => "N-IV-1,23"},
      {:file_path => "", :siglum => "N-IV-1,24"},
      {:file_path => "", :siglum => "N-IV-1,25"},
      {:file_path => "", :siglum => "N-IV-1,26"},
      {:file_path => "", :siglum => "N-IV-1,27"},
      {:file_path => "", :siglum => "N-IV-1,28"}
    ]
    
    render :template => "simple_mode/facsimile_edition/single_page_view", :layout => "facsimile_edition"
   
  end
  
  
end
