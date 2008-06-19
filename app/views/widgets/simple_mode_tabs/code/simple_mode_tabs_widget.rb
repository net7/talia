class SimpleModeTabsWidget < Widgeon::Widget
  
  # This will run during the widget initialization. You can use all options
  # for the widget as class variables, and all class variables that
  # you set will be available as accessors in the template.
  def on_init
  end

  
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
      result << titled_link('boh!', element[:text])
      result << '</li>'
    end
    result << '</ul>'
  end
   
end
