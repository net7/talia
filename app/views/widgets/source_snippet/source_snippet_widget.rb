# Render a source with a given template. The widget checks the type of the 
class SourceSnippetWidget < Widgeon::Widget
  
  def before_render
    assit_not_nil(@source)
  end
  
  # Return the correct partial sub-template for the given Source, depending 
  # on the source type. If not template is found, return 'default't
  def get_item_template
    get_type_template(@source.types)
  end
  
  protected
  
  # Return the template for the given type
  def get_type_template(types)
    template = "default"
    
    # For each of the types, check if the type template exists
    for type in types
      assit_kind_of(N::URI, type)
      type_uri = type.to_name_s('_')
      template = if(Dependencies.mechanism == :require)
        @@type_templates[type_uri] ||= check_type_template(type_uri)
      else
        check_type_template(type_uri)
      end
      
      # When a template is found, break out
      return template unless(template == "default")
    end
    
    template # Otherwise this will return "default"
  end
  
  # Check if the type template exists on disk, otherwise return "default"
  def check_type_template(type)
    assit_kind_of(String, type)
    file_name = File.join(self.class.path_to_self, "_#{type}.rhtml")
    if(FileTest.exists?(file_name))
      type
    else
      "default"
    end
  end
end
