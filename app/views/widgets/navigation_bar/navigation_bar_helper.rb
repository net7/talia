module NavigationBarHelper
  # Creates a link to the given source
  def type_link(text, type)
    link_to(text, {:controller => 'types', :action => 'show', :id => "#{type.namespace}##{type.local_name}"}, :onclick => "navigationGoDown('#{type.namespace}:#{type.local_name}');", :class => "ipodStyle")
  end
  
  # Create a paginator for the current type
  def type_paginator
    @pager = SourcePaginator.new(TaliaCore::TypeRecord.count(:conditions => ["uri = ?", @type.to_s] ), 5, :type => @type)
  end
end
