# Displays a paginated list of sources, using the widgeon will_paginate support.
# This takes the following options:
# 
# * <tt>source_options</tt> - A hash of options that will be passed to 
#                             TaliaCore::Source#paginate to retrieve 
#                             the sources. A page parameter will be silently ignored.
# * <tt>page</tt> - The current page of the pagination. If this is not given, 
#                   the first page is shown.
class SourceListWidget < Widgeon::Widget
  
  def on_init
    raise(ArgumentError, "Source options missing") unless(@source_options)
    @source_options[:page] = get_page   
    @sources = TaliaCore::Source.paginate(@source_options)
    @snippet_dir ||= 'source_list'
  end
  
  # This iterates through all the groups in the source list, passing 
  # two parameters: First, the group name as a string and a collection of
  # elements with the group members
  def groups
    yield("Complete List", @sources)
  end
  
  private
  
  # Get the page for the pagination of the sources. This will return
  # the page parameter that was passed into the widget, if it exists. If not,
  # it will return the saved "page" value from the session - if that exists
  # *and* we are in a callback. Otherwise, this will default to the first page.
  def get_page
    page = @page
    page ||= page_from_session
    widget_session[:page] = page
  end
  
  # Retrieve the page from the widget session, if applicable
  def page_from_session
    if(widget_session[:page] && is_callback?)
      widget_session[:page]
    else
      1
    end
  end
  
  
end
