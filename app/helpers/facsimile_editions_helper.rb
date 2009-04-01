module FacsimileEditionsHelper

  def facsimile_edition_types
    @edition.book_types    
  end
  
  def facsimile_edition_subtypes
    @edition.book_subtypes(N::HYPER + @type)
  end  
  
  # creates the elements to be shown in the tabs, depending on the action we're in
  def book_tabs
    subtypes = @edition.book_subtypes(N::HYPER + params[:type])
    tabs = []
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
      tabs << {:link => "/#{TaliaCore::FacsimileEdition::EDITION_PREFIX}/#{params[:id]}/#{params[:type]}/#{subtype.local_name}", :text => t(:"talia.types.#{subtype.local_name.underscore}"), :selected => selected}
    end
    tabs
  end
    
  def show_tabs
    [{:link => "", :text => t(:'talia.facsimile_edition.editors_introduction'), :selected => true}]
  end
  
  def panorama_tabs
    tabs = []
    subtype = @book.material_subtype
    @edition.books(subtype).each do |book|
      link = book.uri.to_s
      selected = false
      if book == @book
        # we're showing the selected book, no link must be shown, and the style must be "selected"
        link = ''
        selected = true
      end
      tabs << {:link => link, :text => book.name, :selected => selected}
    end
    tabs
  end
  
  def page_tabs
    [{:link => "", :text => @book.name, :selected => true}]
  end
  
  # returns a link to the next page, used in the "page" action
  def facsimile_edition_next_page
    # if we have the @page2 var set, this is the case where two pages are
    # shown (facing pages), otherwise, we'll use the @page one, which is set
    # in any case
    current_page = @page2 || @page
    page = @page.next_page
    result = "<p class='next'><a href='#{page.uri.to_s}'>Next page</a></p>"
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
    result ="<p class='previous'><a href='#{page.uri.to_s}'>Previous page</a></p>"
  rescue
    # @page.previous_page will raise an exception if this is the first page
    # no previous button should be shown, then
    result = ''
  end
 
  # returns the copyright note to be shown below the facsimile images
  def copyright_note(book_part)
    book = book_part.book
    book.dcns::rights.first
  end

  # To indicate if the current page is a double page
  def double_page?
    @double_page
  end
  
end
