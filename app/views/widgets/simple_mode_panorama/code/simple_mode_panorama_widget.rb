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
  
  # called in the panorama page of Macrocontribuitons, it generates a panel
  # with all the thumbnails of the given set of pages (passed through the @elements var) 
  
  def horizontal_panorama
    result = ''
    @elements.each do |element| 
      position = cycle('even', 'odd') 
      if (@elements.first == element) 
        result << "
      <div class='block'>
        <div class='lonely'>"
        result << generate_horizontal_line(element)
        result << '</div>
      </div>
        '
        
      else
        if (position == 'odd') 
          result << '<div class="block">' 
        end 
        result << generate_horizontal_line(element)
        if position == 'even' || @elements.last == element 
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
    "
          <p>
            <a href='fe_single_page_view?mc_uri=#{@mc_uri}&type=#{@mc_type}&material=#{@material}&page=#{element[:siglum]}'>
              <img src='#{element[:file_path]}'/>#{element[:siglum]}
            </a>
          </p>
    "     
  end
        
  def generate_vertical_line (element)
    "
       <a href='fe_single_page_view?mc_uri=#{@mc_uri}&type=#{@mc_type}&material=#{@material}&page=#{element[:siglum]}'>
         <img src='#{element[:file_path]}' alt='#{element[:siglum]}' /> 
          #{element[:siglum]}
       </a>"
  end
end