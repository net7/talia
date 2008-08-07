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
  
  # used in the panorama page of Macrocontributions, it generates a panel
  # with all the thumbnails of the given set of pages (passed through the @elements var) 
  
  def horizontal_panorama(elements)
    result = ''
    elements.each do |el| 
      # elements contains an array of semanticRelations, given by orderedSource
      # we need the _objects_ in there (the actual pages)
      element = el.object
      position = cycle('even', 'odd') 
      if (elements.first.object == element) 
        result << "
      <div class='block'>
        <p class='lonely'>"
        result << panorama_element(element)
        result << '</p></div>
      </div>
        '
        
      else
        if (position == 'odd') 
          result << '<div class="block">' 
        end 
        result << "<p>#{panorama_element(element)}</p>"    
        if position == 'even' || elements.last.object == element 
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
    result = ''
    last_element = ''
    elements.each do |el| 
      # elements contains an array of semanticRelations, given by orderedSource
      # we need the _objects_ in there (the actual pages)
      element = el.object
      position = cycle('even', 'odd')

      if elements.first == element 
        result << "<div class='view_block'>
        <p class='lonely' id='page_#{element}'>
        "
        result << panorama_element(element)
        result << '
</p>
      </div>'
      else 
        if position == 'odd' 
          result << "<div class='view_block'>"
        end 
        result << "<p id='page_#{element}'>
        "
        result << panorama_element(element)
        result << '
</p>'
        if position == 'even' || elements.last.object == element
          result << '</div>'
          if position == 'even' && elements.first.object != element
            # let's create the "facing pages" link. only when tha page has even position
            # and only if it isn't the first one, as the first is displayed on it's on
            # being the cover
            result <<  "<div><a href='#{last_element.uri.to_s}?pages=double&page2=#{element.uri.local_name}'>#{'facing pages'.t}</a></div>"
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
  def panorama_element(element)
    url = "#{element.uri.to_s}"
    image_url = "#{url}.jpeg?size=thumbnail"
    text = "<img src='#{image_url}'/>#{element.uri.local_name}"
    result = "#{titled_link(url, text)}"    
  end
    
        
end