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
      link = "<a class='#{position}_menu_item'"
      link += " href='#{tab_link_target}'"
      link += " title='#{@settings['title']} AccessKey #{@settings['key']}'" 
      link += " accesskey='#{@settings['key']}'>"
      link += text
      link += '</a>'
    end
    
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