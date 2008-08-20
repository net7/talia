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
      result = "#{TaliaCore::SITE_NAME} | #{@facsimile_edition.title}, #{params[:page].t}"
      if (params[:page2])
        result << " - #{params[:page2]}"
      end
      result
    end
  end
  
  # creates the elements to be shown in the path
  def facsimile_edition_path    
    path = []
    case action_name
    when "show"
      path = [{:text => params[:id]}]
    when "books"
      path = [
        {:text => params[:id], :controller => TaliaCore::FacsimileEdition::EDITION_PREFIX, :action => 'show', :id => params[:id]},
        {:text => @type.capitalize.t}
      ]
    when "panorama"
      path = [
        {:text => params[:id], :controller => TaliaCore::FacsimileEdition::EDITION_PREFIX, :action => 'show', :id => params[:id]},
        {:text => @type.capitalize.t, :controller => TaliaCore::FacsimileEdition::EDITION_PREFIX, :action => 'books', :id => params[:id], :type => @type},
        {:text => params[:book] + ' (panorama)'}
      ]
    when "page"
      path =[
        {:text => params[:id], :controller => TaliaCore::FacsimileEdition::EDITION_PREFIX, :action => 'show', :id => params[:id]},
        {:text => @type.capitalize.t, :controller => TaliaCore::FacsimileEdition::EDITION_PREFIX, :action => 'books', :id => params[:id], :type => @type},
        {:text => @book.uri.local_name + ' (panorama)', :controller => TaliaCore::FacsimileEdition::EDITION_PREFIX, :action => 'panorama', :id => params[:id], :book => @book.uri.local_name},
      ]
      text = params[:page]
      if (params[:page2])
        text << " | #{params[:page2]}"
      end
      path << {:text => text}
      path
    end  
  end  
  # decides whether or not the buttons on the top-right of the layout should
  # be shown, based on the action we're in
  def facsimile_edition_display_buttons
    case action_name
    when "show", "books"
      result = false
    when "panorama", "page"
      result = true
    end
    result
  end
   
  def facsimile_edition_types
    @facsimile_edition.book_types    
  end
  
  def facsimile_edition_subtypes
    @facsimile_edition.book_subtypes(N::HYPER + @type)
  end  
  
  # creates the elements to be shown in the tabs, depending on the action we're in
  def tabs_elements
    result = []
    case action_name
    when "show"
      result = [{:link => "", :text => "Editor's Introduction".t, :selected => true}]
    when "books"
      subtypes = @facsimile_edition.book_subtypes(N::HYPER + params[:type])
      if (params[:subtype])
        selected_subtype = N::HYPER + params[:subtype]
      else
        selected_subtype = subtypes[0]
      end
      subtypes.each do |subtype|
        if (subtype == selected_subtype)
          selected = true
        else 
          selected = false
        end
        result << {:link => "/#{TaliaCore::FacsimileEdition::EDITION_PREFIX}/#{params[:id]}/#{params[:type]}/#{subtype.local_name}", :text => subtype.local_name.t, :selected => selected}
      end
    when "panorama"
      result = [{:link => "", :text => params[:book], :selected => true}] 
    when "page"
      result = [{:link => "", :text => @book.uri.local_name, :selected => true}]       
    end
    result
  end
  
  # returns a link to the next page, used in the "page" action
  def facsimile_edition_next_page
    # if we have the @page2 var set, this is the case where two pages are
    # shown (facing pages), otherwise, we'll use the @page one, which is set
    # in any case
    current_page = @page2 || @page
    page = @page.next_page
    result = "<p class='next'><a href='#{page.uri.to_s}'></a></p>"
  rescue
    # @page.next_page will raise an exception if this is the last page
    # no next button should be shown, then
    result = ''
  end
 
  # returns a link to the previous page, used in the "page" action
  def facsimile_edition_previous_page
    # in both single and double pages cases, params[:page] is set
    # In the single page case, it's the only page, in the double pages one it's the
    # first page, and we want it's predecessor
    page = @page.previous_page
    result ="<p class='previous'><a href='#{page.uri.to_s}'></a></p>"
  rescue
    # @page.previous_page will raise an exception if this is the first page
    # no previous button should be shown, then
    result = ''
  end
 
  # returns the copyright note to be shown below the facsimile images
  def copyright_note(page)
    qry = Query.new(TaliaCore::Source).select(:f).distinct
    qry.where(:f, N::HYPER.manifestation_of, page)
    qry.where(:f, N::HYPER.type, N::HYPER.Facsimile)
    facsimile = qry.execute
    facsimile[0].copyright_note if !facsimile.empty?
  end
  
  # returns the material descirption of the given book
  def material_description(book)
    book.material_description
  end
end
