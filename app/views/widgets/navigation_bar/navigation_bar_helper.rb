module NavigationBarHelper
  # Creates a link to the given source, moving the ipod list "down"
  def type_link_down(text, type, level)
    item_id = type.to_name_s('_')
    widget_remotelink(text, :ipod_down, { :navigation_type => type.to_name_s("#"), :navigation_id => item_id, :level => level }, { :class => "ipodStyle", :href => "foo"} )
  end
  
  # Creates a link to the given type, used as an "up" backlink for the ipod navigation
  def type_link_up(text, type)
    link_to(text, "#", { :class => "ipodStyle", :onclick => "defaultNavigationGoUp();" })
  end
  
  # Create a paginator for the current type
  def type_paginator
    @pager = SourcePaginator.new(TaliaCore::TypeRecord.count(:conditions => ["uri = ?", @type.to_s] ), 5, :type => @type)
  end
  
  # Renders the navigation list of level 1
  def navigation_list
    widget_partial("navigation_list", :locals => { :current_level => "1", :widget_subtypes => @widget.subtypes , :widget_supertypes => @widget.supertypes })
  end
end