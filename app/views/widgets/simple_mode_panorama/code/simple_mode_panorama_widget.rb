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
  
  # called in the panorama page of Macrocontribuitons, it generates a panel
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
    result = ''
    last_element = ''
    elements.each do |element| 
      position = cycle('even', 'odd')

      if elements.first == element 
        result << '<div class="view_block">
        <p class="lonely">'
        result << vertical_line(element)
        result << '</p>
      </div>'
      else 
        if position == 'odd' 
          result << '<div class="view_block">'
        end 
        result << '<p>'
        result << vertical_line(element)
        result << '</p>'
        if position == 'even' || elements.last == element
          result << '</div>'
          if position == 'even' && elements.first != element
            result <<  "<a href='fe_double_page_view?mc_uri=#{@mc_uri}&type=#{@mc_type}&material=#{@material}&page1=#{last_element[:siglum]}&page2=#{element[:siglum]}'>#{'facing pages'.t}</a>"
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
    url = "#{params[:book]}/#{element}"
    text = "<img src='#{element[:file_path]}'/>#{element}"
    result = "#{titled_link(url, text)}"    
  end
  
  def vertical_line(element)
    url = "#{element}"
    text = "<img src='#{element[:file_path]}'/>#{element}"
    result = "#{titled_link(url, text)}"    
    
  end
  
        
end