class SimpleModePathWidget < Widgeon::Widget
  
  # This will run during the widget initialization. You can use all options
  # for the widget as class variables, and all class variables that
  # you set will be available as accessors in the template.
  def on_init    
  end
  

  def breadcrumbs 
    # It creates the html of the "navigation path" in the header of the pages
    result = ''
    # @path_elements is an array of hashes, containing all the "steps" in the 
    # navigation path
    @path_elements.each do |element|
      result << ' &gt; '
      url = element[:link]
      text = element[:text]
      if url.nil?
        # if link data are not passed, only the text, with no links, is displayed
        result << text
      else
        # if link data are passed, also a link is created
        #        result << link_to(text, element)       
        result << "<a href='#{url}'>#{text}</a>"
      end
    end
    result
  end

end