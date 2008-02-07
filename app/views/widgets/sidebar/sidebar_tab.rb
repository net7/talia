class SidebarWidget < Widgeon::Widget
  
  # Inner class representing a tab
  class SidebarTab
    
    # Create a new SidebarTab with the given settings
    def initialize(settings, controller)
      assit_kind_of(Hash, settings)
      assit_kind_of(ActionController::Base, controller)
      @settings = settings
      @controller = controller
    end
    
    # Access settings on the tab
    def [](key)
      @settings[key]
    end
    
    # Creates the link that will be called when the tab is clicked. If no 
    # text is given, this will default to the name of the tab.
    def tab_link(text = nil)
      text = @settings['name'] unless(text)
      name_id = "sidbr_" + @settings['name'].downcase.gsub(/\s+/, '_')
      image = @settings['image'] ? @settings['image'] : "side_bar_icon.gif"
      image_ext = File.extname(image)
      image_base = File.basename(image, image_ext)
      image_hover = "#{image_base}_ro#{image_ext}"
      image_selected = "#{image_base}_sel#{image_ext}"
      
#      # First some style properties: TODO: Kludge
      link = "<style type='text/css'>"
        # conidion for the active page
        if @settings['is_active']
           link += "\##{name_id} { background-image: url(/images/#{image_selected}) !important;}"
           link += " \##{name_id}:hover { background-image: url(/images/#{image_selected}) !important;}"
        else
           link += "\##{name_id} { background-image: url(/images/#{image}) !important;}"
           link += " \##{name_id}:hover { background-image: url(/images/#{image_hover}) !important;}"
        end
       link += "</style>"
      # Now the link
      link += "<a class='#{position}_menu_item' id='#{name_id}'"
      link += " href='#{tab_link_target}'"
      link += " title='#{@settings['title']} AccessKey #{@settings['key']}'" 
      link += " accesskey='#{@settings['key']}'"
      link += ">"
      link += text
      link += '</a>'
  end
    
        # Creates the link that will be called when the tab is clicked. If no 
    # text is given, this will default to the name of the tab.
#    def tab_link(text = nil)
#      text = @settings['name'] unless(text)
#      name_id = "sidbr_" + @settings['name'].downcase.gsub(/\s+/, '_')
#      image = @settings['image'] ? @settings['image'] : "side_bar_icon.gif"
#      image_ext = File.extname(image)
#      image_base = File.basename(image, image_ext)
#      image_hover = "#{image_base}_ro#{image_ext}"
#      
#      link = "<a class='#{position}_menu_item' id='#{name_id}'"
#      link += " href='#{tab_link_target}'"
#      link += " title='#{@settings['title']} AccessKey #{@settings['key']}'" 
#      link += " accesskey='#{@settings['key']}'"
#      link += ">"
#      link += "<img src='/images/#{@settings['is_active'] ? image_hover : image}' alt='#{text}' />"
#      link += '</a>'
#    end
    
    # Gets the link target for a tab. If there is no redirect set for this 
    # tab, it returns a void link. Otherwise it builds a link for the
    # redirect.
    def tab_link_target
      if(@settings['redirect'])
        if(@settings['redirect'].is_a?(Hash))
          @controller.url_for(@settings['redirect'])
        else
          @settings['redirect'].to_s
        end
      else
        "javascript:void(#{@settings['key']})"
      end
    end
    
    # Returns a string identifying the position; "top" or "bottom"
    def position
      if(@settings['position'] == "bottom")
        'bottom'
      else
        'top'
      end
    end
    
  end
end