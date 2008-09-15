# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  # Creates a link to the given source
  def source_link(text, source)
    link_to(text, :controller => 'sources', :action => 'show', :id => source.uri.local_name)
  end
  
  # Returns true if the given property has at least one value on the given
  # Source.
  def has_property?(property)
    property && property.any?
  end  
end
