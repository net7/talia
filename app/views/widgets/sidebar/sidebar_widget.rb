class SidebarWidget < Widgeon::Widget
  
  def before_render
    @top_tabs = []
    @bottom_tabs = []
    
    # Create bottom and top lists
    @tabs.each do |name, settings|
      if(settings['position'] == "bottom")
        @bottom_tabs << settings
      else
        @top_tabs << settings
      end
    end
    
    @active_tab_options = {} unless(@active_tab_options)
    @tab_widget = @tabs[@active_tab]['content']
  end
end
