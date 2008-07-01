class SimpleModeTabsWidget < Widgeon::Widget
  
  def tabs
    return if (!@tabs_elements || @tabs_elements.empty?)
    result = ''
    result << '<ul>'
    @tabs_elements.each do |element|
      if (element[:selected]) 
        result << '<li class="selected">' 
      else
        result << '<li>' 
      end
      result << titled_link(element[:link], element[:text])
      result << '</li>'
    end
    result << '</ul>'
  end
   
end
