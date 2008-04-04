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
      klass.label
    end
  end
  
  # This is the callback that updates the scrolling navigation, going down to 
  # the next level
  remote_call :ipod_down do |page, view|
    new_level = (@level.to_i + 1).to_s
    
    page.insert_html(:bottom, @navigation_id, render_template(view, "navigation_list",
        :locals => {:current_level => new_level })
    )
    page.replace_html(@list_element, 
      view.widget(:source_list, :source_options => { :type => @source_class, :per_page => @list_size.to_i })
    )
    page.call('navigationGoDown ', @navigation_id)
  end
  
  # This is the callback that updates the scrolling navigation, going up to the
  # next level
  remote_call :ipod_up do |page, view|
    list_content = "<h2>Please select a type</h2>"
    if(@source_class) 
      list_content =  view.widget(:source_list, :source_options => { :type => @source_class, :per_page => @list_size.to_i })
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
