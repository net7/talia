module NavigationBarHelper
  # Creates a link to the given source, moving the ipod list "down"
  def type_link_down(type, level)
    text = w.class_label(type)
    widget_remote_link(text,  
      { :javascript => :ipod_down,
        :navigation_type => type.to_name_s("#"), 
        :navigation_id => type_id(type), 
        :level => level,
        :fallback => static_url_for(type)
      }, 
      { :class => "ipodStyle" } )
  end
  
  # Title element for the navigation
  def navigation_title
    w.source_class ? w.class_label(w.source_class) : "Navigate!"
  end
  
  # Creates a link to the given type, used as an "up" backlink for the ipod navigation
  def type_link_up(type)
    text = type.is_a?(String) ? type : w.class_label(type)
    link_to(text, static_url_for(type), { :class => "ipodStyle", :onclick => "defaultNavigationGoUp();" })
  end
  
  # Create a paginator for the current type
  def type_paginator
    @pager = SourcePaginator.new(TaliaCore::TypeRecord.count(:conditions => ["uri = ?", @type.to_s] ), 5, :type => @type)
  end
  
  # Renders the navigation list of level 1
  def navigation_list
    widget_partial("navigation_list", 
      :locals => { :current_level => "1" })
  end
  
  private
  
  
  # Creates a static url for the given type
  def static_url_for(type)
    return w.request.params if(type.is_a?(String))
    static_url_params = w.request.parameters
    if(type)
      static_url_params[:id] = type_id(type)
    end
    url_for(static_url_params)
  end
  
  # Get a type id/string
  def type_id(type)
    type.to_name_s('_')
  end
  
end