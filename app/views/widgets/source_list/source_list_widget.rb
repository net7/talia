# Displays a paginated list of sources, using the widgeon will_paginate support.
# This takes the following options:
# 
# * <tt>source_options</tt> - A hash of options that will be passed to 
#                             TaliaCore::Source#paginate to retrieve 
#                             the sources. A page parameter will be silently ignored.
# * <tt>page</tt> - The current page of the pagination. If this is not given, 
#                   the first page is shown.
class SourceListWidget < Widgeon::Widget
  
  ITEMS_PER_PAGE = 5
  
  def before_render
    raise(ArgumentError, "Source options missing") unless(@source_options)
    @source_options[:page] = @page ? @page : 1    
    @sources = TaliaCore::Source.paginate(@source_options.dup)
  end
  
  
end
