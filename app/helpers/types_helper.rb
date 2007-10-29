module TypesHelper
  # Creates a link to the given source
  def type_link(text, type)
    link_to(text, :controller => 'types', :action => 'show', :id => "#{type.namespace}##{type.local_name}")
  end
end
