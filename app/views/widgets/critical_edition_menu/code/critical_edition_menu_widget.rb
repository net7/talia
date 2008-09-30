class CriticalEditionMenuWidget < Widgeon::Widget

  def on_init
    @advanced_search = false if @advanced_search.nil?
  end
  
  # show bool list
  def show_books
    result = "<ul class='toplevel book'>"
    # add an <li> tag for each book
    @books.each do |item|
      item_uri = ''
      # check if advanced_search is true
      if !@advanced_search
        # add an <li> item for standard menu
        item_uri = item.uri.to_s
        result << "<li id='#{item_uri}_menu'><a href='#{item_uri}'>#{item.dcns.title}</a></li>"
      else
        # add an <li> item for advanced search menu
        item_uri = item.elements['talia:uri'].text.strip
        result << "<li id='#{item_uri}_menu'><a href='#' onclick='document[\"advanced_search_menu_form\"].mc_single.value=\"#{item_uri}\";document[\"advanced_search_menu_form\"].submit();return false'>#{item.elements['talia:title'].text.strip}</a></li>"
      end
    
      # if current item is the chosen book, show book's chapters
      if (!@chosen_book.nil? && @chosen_book.uri.to_s == item_uri)
        # get chpaters
        if !@advanced_search
          chapters = item.chapters
        else
          chapters = item.get_elements('talia:group')
        end
      
        if !chapters.empty?
          # for each chapter, add an <li> item
          chapters.each do |element|
            result << show_chapter(element)
          end
        else
          chapters = item.subparts_with_manifestations(N::HYPER.HyperEdition)
        
          chapters.each do |element|
            result << show_part(element)
          end
        end
      
      end
    end
    
    result << "</ul>"
    return result
  end
  
  def show_chapter(item)
    # show second level list
    result = "<ul class='secondlevel pages'>"
        
    item_uri = ''
    
    # check if advanced_search is true
    if !@advanced_search
      item_uri = item.uri.to_s
      result << "<li id='#{item_uri}_menu'><a href='#{item_uri}'>#{item.dcns.title}</a></li>"
    else
      item_uri = item.elements['talia:uri'].text.strip
      result << "<li id='#{item_uri}_menu'><a href='#' onclick='document[\"advanced_search_menu_form\"].mc_single.value=\"#{item_uri}\";document[\"advanced_search_menu_form\"].submit();return false'>#{item.elements['talia:title'].text.strip}</a></li>"
    end

    if (!@chosen_chapter.nil? && @chosen_chapter.uri.to_s == item_uri)
      
      parts = []
      if !@advanced_search
        parts = item.subparts_with_manifestations(N::HYPER.HyperEdition)
      else
        parts = item.get_elements('talia:group')
      end
    
      parts.each do |element|
        result << show_part(element)
      end
    end
    
    result << "</ul>"
    return result
  end
  
  def show_part(item)
    result = "<ul class='thirdlevel page'>"
    # check if advanced_search is true
    if !@advanced_search
      title = item.dcns.title.empty? ? item.uri.local_name : item.dcns.title
      uri = item.uri.to_s
      result << "<li id='#{uri}_menu'><a href='#{uri}'>#{title}</a></li>"
    else
      title = item.elements['talia:title'].text.strip
      uri = item.elements['talia:uri'].text.strip
      result << "<li id='#{uri}_menu'><a href='#' onclick='document[\"advanced_search_menu_form\"].mc_single.value=\"#{uri}\";document[\"advanced_search_menu_form\"].submit();return false'>#{title}</a></li>"
    end
    
    result << "</ul>"
    
    return result
  end
  
  def show_hidden_field
    result = ''
    
    # add 'search_type' field
    result << w.hidden_field_tag('search_type', params[:search_type])
    # add 'words' field
    result << w.hidden_field_tag('words', params[:words])
    # add 'operator' field
    result << w.hidden_field_tag('operator', params[:operator])
    
    result << w.hidden_field_tag('mc[]', params[:mc] || [])
    result << w.hidden_field_tag('mc_from[]', params[:mc_from] || [])
    result << w.hidden_field_tag('mc_to[]', params[:mc_to] || [])

    return result
  end
  
  def menu
    @out =  "<ul class='toplevel book'>"
    @books.each do |book|
      @out << "<li id='#{book.uri.to_s}_menu'><a href='#{book.uri.to_s}'>#{book.dcns.title}</a></li>"
      if @chosen_book == book
        @out << "<ul class='secondlevel pages'>"
        chapters = book.chapters
        if !chapters.empty?
          # the book has chapters, let's add them to the menu
          chapters.each do |chapter|
            @out << "<li id='#{chapter.uri.to_s}_menu'><a href='#{chapter.uri.to_s}'>#{chapter.dcns.title}</a></li>"
            if @chosen_chapter == chapter 
              @out << "<ul class='thirdlevel page'>"
              chapter.subparts_with_manifestations(N::HYPER.HyperEdition).each do |part|
                # If the part has no title, let's use its "siglum" as a title
                title = part.dcns.title.empty? ? part.uri.local_name : part.dcns.title
                @out << "<li id='#{part.uri.to_s}_menu'><a href='#{part.uri.to_s}'>#{title}</a></li>"
              end
              @out << '</ul>'
            end
       
          end
        else
          # the book has no chapters, we'll add pages/paragraphs directly under the book itself
          book.subparts_with_manifestations(N::HYPER.HyperEdition).each do |part|
            @out << "<ul class='thirdlevel page'>"
            title = part.dcns.title.empty? ? part.uri.local_name : part.dcns.title
            @out << "<li id='#{part.uri.to_s}_menu'><a href='#{part.uri.to_s}'>#{title}</a></li>"
            @out << '</ul>'
          end 
        end
        @out << '</ul>'
      end
    end
    @out << '</ul>'
  end
  
end