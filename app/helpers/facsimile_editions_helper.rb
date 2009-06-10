module FacsimileEditionsHelper

  def facsimile_edition_types
    @edition.book_types    
  end
  
  def facsimile_edition_subtypes
    @edition.book_subtypes(N::HYPER + @type)
  end

  # Creates a title for the page, using the current book
  def part_title(page)
    page_str = t(:"talia.global.page")
    pos_str = page.position_name || page.uri.local_name
    "#{@book.name},  #{page_str} #{pos_str}."
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
      tabs << {:link => "/#{TaliaCore::FacsimileEdition::EDITION_PREFIX}/#{params[:id]}/#{params[:type]}/#{subtype.local_name}", :text => t(:"talia.types.#{subtype.local_name}"), :selected => selected}
    end
    tabs
  end
    
  def show_tabs
    []
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
    next_page = (@page2 || @page).next_page
    return '' unless(next_page)
    
    uri = if(@page2)
      # If we have 2 pages, we build a double-page URL for the next double page
      past_next = next_page.next_page
      # Add the double-uri only if the page after the next exists, otherwise
      # behave like a single page links
      next_page.uri + (past_next ? "/#{past_next.uri.local_name}" : '')
    else
      next_page.uri
    end
    "<p class='next'><a href='#{uri}'>Next page</a></p>"
  rescue
    # @page.next_page will raise an exception if this is the last page
    # no next button should be shown, then
    ''
  end
 
  # returns a link to the previous page, used in the "page" action
  def facsimile_edition_previous_page
    # in both single and double pages cases, params[:page] is set
    # In the single page case, it's the only page, in the double pages one it's the
    # first page, and we want it's predecessor
    previous_page = @page.previous_page
    return '' unless(previous_page)
    
    uri = if(@page2)
      second_page = previous_page
      first_page = second_page.previous_page
      # Check if we have two pages before this one. Othewise make a 'single' link
      if(first_page)
        first_page.uri + "/#{second_page.uri.local_name}"
      else
        second_page.uri
      end
    else
      previous_page.uri
    end
    "<p class='previous'><a href='#{uri}'>Previous page</a></p>"
  rescue Exception => e
    puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX #{e.message}"
    # @page.previous_page will raise an exception if this is the first page
    # no previous button should be shown, then
    ''
  end
 
  # returns the copyright note to be shown below the facsimile images
  def copyright_note(book_part)
    book = book_part.book
    book.dcns::rights.first
  end

  # To indicate if the current page is a double page
  def double_pages?
    @double_pages
  end
  
end
