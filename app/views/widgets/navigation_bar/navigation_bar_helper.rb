module NavigationBarHelper
  # Creates a link to the given source
  def type_link(text, type, level)
    widget_remotelink(text, :ipod_load, { :navigation_type => type.to_name_s("#"), :level => level }, { :class => "ipodStyle", :href => "foo"} )
    # link_to(text, {:controller => 'types', :action => 'show', :id => "#{type.namespace}##{type.local_name}"}, :onclick => "navigationGoDown('#{type.namespace}:#{type.local_name}');", :class => "ipodStyle")
  end
  
  # Create a paginator for the current type
  def type_paginator
    @pager = SourcePaginator.new(TaliaCore::TypeRecord.count(:conditions => ["uri = ?", @type.to_s] ), 5, :type => @type)
  end
  
  # Renders the navigation list of level 1
  def navigation_list
    widget_partial("navigation_list", :locals => { :current_level => "1", :widget_subtypes => @widget.subtypes })
  end
end