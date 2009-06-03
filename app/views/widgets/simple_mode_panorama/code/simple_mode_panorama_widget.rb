# TODO: This could use some cleaning
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
    elements.each do |element| 
      position = cycle('even', 'odd') 
      if (elements.first == element) 
        result << "
      <div class='block'>
        <p class='lonely'>"
        result << thumb_link(element)
        result << '<span>' 
        result << element.uri.local_name  
        result << "</span></p></div>
        </div>"
      else
        if (position == 'odd') 
          result << '<div class="block">' 
        end 
        result << "<p>#{thumb_link(element)}<span>#{element.uri.local_name}</span></p>"    
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
    result = ''
    last_element = ''
    elements.each do |element|
      position = cycle('even', 'odd')

      if elements.first == element 
        result << "<div class='view_block'>
        <p class='lonely' id='page_#{element}'>
        "
        result << thumb_link(element)
        result << '<span>'
        result << element.uri.local_name + '
</span></p>
      </div>'
      else 
        if position == 'odd' 
          result << "<div class='view_block'>"
        end 
        result << "<p id='page_#{element}'>
        "
        result << thumb_link(element)
        result << '<span>'
        result << element.uri.local_name + '
</span></p>'
        if position == 'even' || elements.last == element
          result << '</div>'
          if position == 'even' && elements.first != element
            # let's create the "facing pages" link. only when tha page has even position
            # and only if it isn't the first one, as the first is displayed on it's on
            # being the cover
            result <<  "<div class='facing_pages'><a href='#{last_element.uri.to_s}/#{element.uri.local_name}'>#{t(:"talia.global.facing_pages")}</a></div>"
          end
          result << ' 
          <!--view_block-->'
        end 
      end
      last_element = element      
    end 
    result
  end  
        
end