class NavigationBarWidget < Widgeon::Widget
  
  include TaliaCore
  
  def on_init
    assit_kind_of(Array, @root_classes, "Must configure root classes correctly.")
    assit_kind_of(Array, @allowed_namespaces, "Must configure the allowed namespaces.")
    
    @show_home = false # normally don't show the home/back link
   
    # We'll get the @navigation_type when the navigation is in callback
    if(@navigation_type && @navigation_type != 'root')
      @source_class = N::SourceClass.make_uri(@navigation_type, "#")
    end
    
    if(@source_class)
      raise(ArgumentError, "This type is not allowed for the browser: #{@source_class.to_name_s}") unless(is_allowed?(@source_class))
      if(is_root?(@source_class))
        @supertypes = []
        @show_home = true # for a root class show the "back" link to the root level
      else
        @supertypes = clean_types(@source_class.supertypes) # Otherwise show the supertypes
      end 
      @subtypes = clean_types(@source_class.subtypes)
    else
      @supertypes = []
      @subtypes = root_class_objects
    end
  end
  
  # Returns the label for the type. This will first try the label configured
  # in the config file. If there's none, it fetches the label from the
  # N::SourceClass
  def class_label(klass)
    if(@labels && @labels[klass.to_name_s])
      @labels[klass.to_name_s]
    else
      klass.rdf_label
    end
  end
  
  # Creates the "up" links in the navigation list
  def navigation_up_links
    result = ""
    if(show_home)
      result << w.partial("navigation_up_link", :locals => { :type => "Back" })
    end
    for supertype in supertypes 
      result << w.partial("navigation_up_link", :locals => { :type => supertype })
    end
    result
  end
  
  # Creates the "down links in the navigation list
  def navigation_down_links(level)
    result = ""
    for subtype in subtypes
      result << w.partial("navigation_down_link", :locals => { :type => subtype, :level => level })
    end
    result
  end
  
  # Creates a link to the given source, moving the ipod list "down"
  def type_link_down(type, level)
    text = class_label(type)
    w.remote_link(text,  
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
    text = type.is_a?(String) ? type : class_label(type)
    w.remote_link(text,
    {
      :javascript => :ipod_up,
      :navigation_type => type.is_a?(String) ? "root" : type.to_name_s('#'),
      :fallback => static_url_for(type)
    },
    { :class => "ipodStyle" } )
  end
  
  # Title element for the navigation
  def navigation_title
    source_class ? class_label(source_class) : "Source Types"
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
    w.partial("navigation_list", 
      :locals => { :current_level => "1" })
  end
  
  private
  
  
  # Creates a static url for the given type
  def static_url_for(type)
    return request.params if(type.is_a?(String))
    static_url_params = request.parameters
    if(type)
      static_url_params[:id] = type_id(type)
    end
    url_for(static_url_params)
  end
  
  # Get a type id/string
  def type_id(type)
    type.to_name_s('_')
  end
  
  # This is the callback that updates the scrolling navigation, going down to 
  # the next level
  callback :ipod_down do |page|
    new_level = (@level.to_i + 1).to_s
    
    page.insert_html(:bottom, @navigation_id, render_template("navigation_list",
        :locals => {:current_level => new_level })
    )
    page.replace_html(@list_element, 
      view.widget(:source_list, :id => 'types_list', :source_options => { :type => @source_class, :per_page => @list_size.to_i })
    )
    page.call('navigationGoDown ', @navigation_id)
  end
  
  # This is the callback that updates the scrolling navigation, going up to the
  # next level
  callback :ipod_up do |page|
    list_content = "<h2>Please select a type</h2>"
    if(@source_class) 
      list_content =  view.widget(:source_list, :id => 'types_list', :source_options => { :type => @source_class, :per_page => @list_size.to_i })
    end
    page.replace_html(@list_element, list_content)
    page.call('defaultNavigationGoUp')
  end
  
  protected
  
  # Checks if the given element is a "root" class
  def is_root?(klass)
    assit_kind_of(N::SourceClass, klass)
    @root_classes.include?(klass.to_name_s)
  end
  
  # Get the root classes as N::SourceClass objects
  def root_class_objects
    @root_classes.collect { |klass| N::SourceClass.new(N::URI::make_uri(klass)) }
  end
  
  # Checks if the given class is in one of the "allowed" namespaces
  def is_allowed?(klass)
    @allowed_namespaces.include?(klass.namespace.to_s)
  end
  
  # Cleans the list of types, by rejecting those which are not contained in the
  # allowed namespaces.
  def clean_types(types)
    types.find_all { |type| is_allowed?(type) } 
  end
  
end
