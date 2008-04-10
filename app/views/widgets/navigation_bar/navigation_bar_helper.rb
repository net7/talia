module NavigationBarHelper
 
  # Creates the "up" links in the navigation list
  def navigation_up_links
    result = ""
    if(w.show_home)
      result << widget_partial("navigation_up_link", :locals => { :type => "Back" })
    end
    for supertype in w.supertypes 
      result << widget_partial("navigation_up_link", :locals => { :type => supertype })
    end
    result
  end
  
  # Creates the "down links in the navigation list
  def navigation_down_links(level)
    result = ""
    for subtype in w.subtypes
      result << widget_partial("navigation_down_link", :locals => { :type => subtype, :level => level })
    end
    result
  end
  
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
  
  # Creates a link to the given type, used as an "up" backlink for the ipod navigation
  def type_link_up(type)
    text = type.is_a?(String) ? type : w.class_label(type)
    widget_remote_link(text,
    {
      :javascript => :ipod_up,
      :navigation_type => type.is_a?(String) ? "root" : type.to_name_s('#'),
      :fallback => static_url_for(type)
    },
    { :class => "ipodStyle" } )
  end
  
  # Title element for the navigation
  def navigation_title
    w.source_class ? w.class_label(w.source_class) : "Source Types"
  end
  
  # Creates an css id for the given type
  def id_for(type)
    type.is_a?(String) ? type.downcase : type_id(type)
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