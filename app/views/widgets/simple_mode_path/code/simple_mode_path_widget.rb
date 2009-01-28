class SimpleModePathWidget < Widgeon::Widget
  
  # This will run during the widget initialization. You can use all options
  # for the widget as class variables, and all class variables that
  # you set will be available as accessors in the template.
  def on_init    
  end
  
  # It creates the html of the "navigation path" in the header of the pages
  def breadcrumbs
    returning html = separator do
      html << @path_elements.map do |element|
        url = element[:link]
        text = element[:text]
        unless url.blank?
          url = "/#{url}" unless /^\//.match(url) || /^http/.match(url)
          %(<a href="#{url}" title="#{text}">#{text}</a>)
        else
          text
        end
      end * separator
    end
  end

  protected
    def separator
      ' &gt; '
    end
end