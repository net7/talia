class NavigationBarWidget < Widgeon::Widget
  
  include TaliaCore
  
  def before_render
    assit_kind_of(Array, @root_classes, "Must configure root classes correctly.")
    assit_kind_of(Array, @allowed_namespaces, "Must configure the allowed namespaces.")
    
    @show_home = false # normally don't show the home/back link
    
    if(@source_class)
      raise(ArgumentError, "This type is not allowed for the browser") unless(is_allowed?(@source_class))
      if(is_root?(source_class))
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
  
  remote_call :ipod_load do |page|
    new_level = (@level.to_i + 1).to_s
    new_type = N::SourceClass.make_uri(@navigation_type, "#")
    
    page.insert_html(:bottom, "ipod_nav_level_#{@level}", 
      :partial => "widgets/#{self.class.widget_name}/navigation_list",
      :locals => {:widget => self, :current_level => new_level, :widget_subtypes => clean_types(new_type.subtypes)})
    page.call('scrollNavigation', new_level)
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
