module NavigationBarHelper
  # Creates a link to the given source, moving the ipod list "down"
  def type_link_down(text, type, level)
    widget_remotelink(text, :ipod_down, 
      { :navigation_type => type.to_name_s("#"), 
        :navigation_id => type_id(type), 
        :level => level }, 
      { :class => "ipodStyle", :href => static_url_for(type) } )
  end
  
  # Creates a link to the given type, used as an "up" backlink for the ipod navigation
  def type_link_up(text, type)
    link_to(text, static_url_for(type), { :class => "ipodStyle", :onclick => "defaultNavigationGoUp();" })
  end
  
  # Create a paginator for the current type
  def type_paginator
    @pager = SourcePaginator.new(TaliaCore::TypeRecord.count(:conditions => ["uri = ?", @type.to_s] ), 5, :type => @type)
  end
  
  # Renders the navigation list of level 1
  def navigation_list
    widget_partial("navigation_list", :locals => { :current_level => "1", :widget_subtypes => @widget.subtypes , :widget_supertypes => @widget.supertypes })
  end
  
  private
  
  # Creates a static url for the given type
  def static_url_for(type)
    static_url_params = @widget.request.parameters
    static_url_params[:id] = type_id(type)
    static_url = url_for(static_url_params)
  end
  
  # Get a type id/string
  def type_id(type)
    type.to_name_s('_')
  end
  
end