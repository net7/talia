module FacsimileEditionsHelper
  # creates the elements to be shown in the path
  def path    
    case action_name
    when "show"
      path = [{:text => params[:id]}]
    when "books"
      path = [
        {:text => params[:id], :controller => 'facsimile_editions', :action => 'show', :id => params[:id]},
        {:text => @type.capitalize.t}
      ]
    when "panorama"
      path = [
        {:text => params[:id], :controller => 'facsimile_editions', :action => 'show', :id => params[:id]},
        {:text => @type.capitalize.t, :controller => 'facsimile_editions', :action => 'books', :id => params[:id], :type => @type},
        {:text => params[:book]}
      ]
    when "page"
      path =[
        {:text => params[:id], :controller => 'facsimile_editions', :action => 'show', :id => params[:id]},
        {:text => @type.capitalize.t, :controller => 'facsimile_editions', :action => 'books', :id => params[:id], :type => @type},
        {:text => params[:book], :controller => 'facsimile_editions', :action => 'panorama', :id => params[:id], :book => params[:book]},
        {:text => params[:page]}
      ]
    end
    path
  end  
   
  def display_buttons
    case action_name
    when "show"
    when "books"
      result = false
    when "panorama"
      result = true
    end
    result
  end
   
  def types
    @facsimile_edition.types    
  end
  
  def subtypes
    @facsimile_edition.subtypes(@type)
  end  
  
  def tabs_elements
    case action_name
    when "show"
      result = [{:text => "Editor's Introduction".t, :selected => true}]
    when "books"
      result = []
    when "panorama"
      result = [{:link =>"",:text => params[:book], :selected => true}] 
    when "page"
      result = [{:link =>"",:text => params[:book], :selected => true}]       
    else
      result =[]
    end
  end
  
  def next_page
    page = @facsimile_edition.neighbour_source(params[:page],'next')
    result ="<p class='next'><a href='#{page}'></a></p>"
  end
  
  def previous_page
    page = @facsimile_edition.neighbour_source(params[:page],'previous')
    result ="<p class='previous'><a href='#{page}'></a></p>"
  end
end
