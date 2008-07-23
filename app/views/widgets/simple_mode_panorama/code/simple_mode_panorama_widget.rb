class SimpleModePanoramaWidget < Widgeon::Widget
  def panorama(elements)
    case @panorama_type
    when 'horizontal' 
      result = horizontal_panorama(elements)
    when 'vertical'
      result = vertical_panorama(elements)
    end
    result
  end
  
  # used in the panorama page of Macrocontribuitons, it generates a panel
  # with all the thumbnails of the given set of pages (passed through the @elements var) 
  
  def horizontal_panorama(elements)
    result = ''
    elements.each do |element| 
      position = cycle('even', 'odd') 
      if (elements.first == element) 
        result << "
      <div class='block'>
        <p class='lonely'>"
        result << horizontal_line(element)
        result << '</p></div>
      </div>
        '
        
      else
        if (position == 'odd') 
          result << '<div class="block">' 
        end 
        result << "<p>#{horizontal_line(element)}</p>"    
        if position == 'even' || elements.last == element 
          result << '</div>
          ' 
        end   
      end
    end 
    result
  end
  
  
  # used in the page showing the large facsimile in the facsimile edition, it
  # generates a panel with all the thumbnails of the pages passed through the 
  # @elements var
  def vertical_panorama(elements)
    #TODO: create a Book class to use the following
    #    book = TaliaCore::Book.find(N::LOCAL + params[:book])
    #    book_type = book.supertype 
    #TODO: instead of this:
    book_type = 'manuscript'
    result = ''
    last_element = ''
    elements.each do |element| 
      position = cycle('even', 'odd')

      if elements.first == element 
        result << "<div class='view_block'>
        <p class='lonely' id='page_#{element}'>
        "
        result << vertical_line(element)
        result << '
</p>
      </div>'
      else 
        if position == 'odd' 
          result << "<div class='view_block'>"
        end 
        result << "<p id='page_#{element}'>
        "
        result << vertical_line(element)
        result << '
</p>'
        if position == 'even' || elements.last == element
          result << '</div>'
          if position == 'even' && elements.first != element
            result <<  "<div><a href='/#{TaliaCore::FACSIMILE_EDITION_PREFIX}/#{params[:id]}/#{params[:book]}/#{last_element}/#{element}'>#{'facing pages'.t}</a></div>"
          end
          result << ' 
          <!--view_block-->'
        end 
      end
      last_element = element      
    end 
    result
  end
    
  private 
  def horizontal_line(element)
    url = "/#{TaliaCore::FACSIMILE_EDITION_PREFIX}/#{params[:id]}/#{params[:book]}/#{element}"
    image_url = "/#{TaliaCore::FACSIMILE_EDITION_PREFIX}/#{params[:id]}/#{params[:book]}/#{element}.jpeg?size=thumbnail"
    #image_url = formatted_facsimile_edition_book_page(params[:id], params[:book], element)

    text = "<img src='#{image_url}'/>#{element}"
    result = "#{titled_link(url, text)}"    
  end
  
  def vertical_line(element)
    url = "/#{TaliaCore::FACSIMILE_EDITION_PREFIX}/#{params[:id]}/#{params[:book]}/#{element}"
    image_url = "/#{TaliaCore::FACSIMILE_EDITION_PREFIX}/#{params[:id]}/#{params[:book]}/#{element}.jpeg?size=thumbnail"
    text = "<img src='#{image_url}'/>#{element}"
    result = "#{titled_link(url, text)}"  
  end
  
        
end