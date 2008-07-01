class SimpleModePanoramaWidget < Widgeon::Widget
  def panorama
    case @panorama_type
    when 'horizontal' 
      result = horizontal_panorama
    when 'vertical'
      result = vertical_panorama
    end
    result
  end
  
  def horizontal_panorama
    result = ''
    @elements.each do |element| 
      position = cycle('even', 'odd') 
      if (@elements.first == element) 
        result << "<div class='block'>
          <div class='lonely'>"
        result << generate_horizontal_line(element)
        result << "</div>
        </div>"
      else
        if (position == 'odd') 
          result << '<div class="block">' 
        end 
        result << generate_horizontal_line(element)
        if position == 'even' || @elements.last == element 
          result << '</div>' 
        end   
      end
    end 
    result
  end
  
  
  def vertical_panorama
    result = ''
    @elements.each do |element| 
      position = cycle('even', 'odd') 
      if @elements.first == element 
        result << '<div class="view_block">
        <p class="lonely">'
        result << generate_vertical_line(element)
        result << '</p>
      </div>'
      else 
        if position == 'odd' 
          result << '<div class="view_block">'
        end 
        result << '<p>'
        result << generate_vertical_line(element)
        result << '</p>'
        if position == 'even' || @elements.last == element
          result << '</div>
          <!--view_block-->'
        end 
      end 
    end 
    result
  end
    
  private 
  def generate_horizontal_line (element)
    "<p>
       <a href='single_page_view?mc=#{@mc}&type=#{@mc_type}&material=#{@material}&page=#{element[:siglum]}'>
          <img src='#{element[:file_path]}'/>#{element[:siglum]}
          </a>
     </p>"     
  end
        
  def generate_vertical_line (element)
    "<img src='#{element[:file_path]}' alt='#{element[:siglum]}' /> 
    #{element[:siglum]}"
  end
end