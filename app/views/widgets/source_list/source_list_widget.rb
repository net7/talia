require 'pagination/source_paginator'
# Displays a list of sources. If a @pager object is passed, this will used 
# as a data source. Otherwise a new pager is constructed.
# If @pager_opts are given, these will be used in the #find operation of the
# pager
class SourceListWidget < Widgeon::Widget
  
  ITEMS_PER_PAGE = 5
  
  def before_render
    create_pager
    @sel_page ||= 1
    @page = @pager.page(@sel_page)
  end
  
  # Creates the pager for this widget. This will use any pager options provided
  def create_pager
    return if(@pager) # Leave an existing pager alone
    raise(ArgumentError, "Must have @pager_opts to create a pager") unless(@pager_state)
    @pager = SourcePaginator.new(@pager_state[:count], @pager_state[:per_page], @pager_state[:query_options])
  end
end
