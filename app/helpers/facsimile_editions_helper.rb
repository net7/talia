module FacsimileEditionsHelper
  # creates the window title 
  def facsimile_edition_page_title
    case action_name
    when "show"
      "#{TaliaCore::SITE_NAME} | #{@facsimile_edition.title}"
    when "books"      
      "#{TaliaCore::SITE_NAME} | #{@facsimile_edition.title}, #{params[:type].t.titleize}"
    when "panorama"
      "#{TaliaCore::SITE_NAME} | #{@facsimile_edition.title}, #{params[:book].t}" 
    when "page"
      "#{TaliaCore::SITE_NAME} | #{@facsimile_edition.title}, #{params[:page].t}"      
    when "facing_pages"
      "#{TaliaCore::SITE_NAME} | #{@facsimile_edition.title}, #{params[:page].t} - #{params[:page2].t}"  

    end
  end
  
  # creates the elements to be shown in the path
  def path    
    path = []
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
        {:text => params[:book] + ' (panorama)'}
      ]
    when "page"
      path =[
        {:text => params[:id], :controller => 'facsimile_editions', :action => 'show', :id => params[:id]},
        {:text => @type.capitalize.t, :controller => 'facsimile_editions', :action => 'books', :id => params[:id], :type => @type},
        {:text => params[:book] + ' (panorama)', :controller => 'facsimile_editions', :action => 'panorama', :id => params[:id], :book => params[:book]},
        {:text => params[:page]}
      ]
    when "facing_pages"
      path = [
        {:text => params[:id], :controller => 'facsimile_editions', :action => 'show', :id => params[:id]},
        {:text => @type.capitalize.t, :controller => 'facsimile_editions', :action => 'books', :id => params[:id], :type => @type},
        {:text => params[:book] + ' (panorama)' , :controller => 'facsimile_editions', :action => 'panorama', :id => params[:id], :book => params[:book]},
        {:text => params[:page] + " | " + params[:page2]}
      ]
    end
    path
  end  
  
  # decides whether or not the buttons on the top-right of the layout should
  # be shown, based on the action we're in
  def display_buttons
    case action_name
    when "show", "books", "facing_pages"
      result = false
    when "panorama", "page"
      result = true
    end
    result
  end
   
  def types
    @facsimile_edition.types    
  end
  
  def subtypes
    @facsimile_edition.subtypes(N::LOCAL + @type)
  end  
  
  # creates the elements to be shown in the tabs, depending on the action we're in
  def tabs_elements
    result = []
    case action_name
    when "show"
      result = [{:link => "", :text => "Editor's Introduction".t, :selected => true}]
    when "books"
      subtypes = @facsimile_edition.subtypes(N::LOCAL + params[:type])
      selected_subtype = params[:subtype] || subtypes[0]
      subtypes.each do |subtype|
        if (subtype == selected_subtype)
          selected = true
        else 
          selected = false
        end
        result << {:link => "/#{TaliaCore::FACSIMILE_EDITION_PREFIX}/#{params[:id]}/#{params[:type]}/#{subtype}", :text => subtype.t, :selected => selected}
      end
    when "panorama"
      result = [{:link => "", :text => params[:book], :selected => true}] 
    when "page"
      result = [{:link => "", :text => params[:book], :selected => true}]       
    when "facing_pages"
      result = [{:link => "", :text => params[:book], :selected => true}]
    end
    result
  end
  
  # returns a link to the next page, used in the "page" action
  def next_page
    current_page = params[:page2] || params[:page]
    page = @facsimile_edition.neighbour_page(N::HYPER + current_page,'next')
    result ="<p class='next'><a href='#{page}'></a></p>"
  end
 
  # returns a link to the previous page, used in the "page" action
  def previous_page
    # in both single and facing pages view, params[:page] is set
    # In the single page case, it's the only page, in the facing pages one it's the
    # first page, and we want it's predecessor
    page = @facsimile_edition.neighbour_page(N::HYPER + params[:page],'previous')
    result ="<p class='previous'><a href='#{page}'></a></p>"
  end
 
  # returns the copyright note to be shown below the facsimile images
  def copyright_note(page)
      qry = Query.new(TaliaCore::Facsimile).select(:f).distinct
      qry.where(:f, N::HYPER.manifestation_of, page)
#      qry.where(:f, N::HYPER.type, N::HYPER + "Facsimile")
      facsimile = qry.execute
      facsimile[0].copyright_note if !facsimile.empty?
  end
  
  # returns the material descirption of the given book
  def material_description(book)
    TaliaCore::Book.find(book).material_description
  end
end
