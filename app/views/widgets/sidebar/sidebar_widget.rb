# Load instead of require, helps with debugging.
load File.join(File.dirname(__FILE__), 'sidebar_tab.rb')

class SidebarWidget < Widgeon::Widget
  
  def before_render
    @top_tabs = []
    @bottom_tabs = []
    new_tabs = []
    
    # Create bottom and top lists
    tabs.each do |tab|
      # Add a setting so the tab can check if it's the active one
      tab['is_active'] = (@active_tab == tab['id'])
      tab_obj = SidebarTab.new(tab, @controller)
      if(tab['position'] == "bottom")
        @bottom_tabs << tab_obj
      else
        @top_tabs << tab_obj
      end
      new_tabs << tab_obj
    end
    
    tabs = new_tabs
    
    @active_tab_options = {} unless(@active_tab_options)
    @tab_widget = the_active_tab['content']
  end
  
  
  # Gets the currently active tab
  def the_active_tab
    @the_active_tab ||= tabs.find { |tab| tab['id'] == @active_tab }
  end
  
  # Gets the title for the sidebar. If the 'sidebar_title' property is set,
  # this will be used. Otherwise, this will use the title that is configured
  # for the currently active tab.
  def title
    if(@sidebar_title)
      @sidebar_title
    else
      the_active_tab['title']
    end
  end
  
end
