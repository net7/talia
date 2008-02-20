# Displays a list of sources. If a @pager object is passed, this will used 
# as a data source. Otherwise a new pager is constructed.
# If @pager_opts are given, these will be used in the #find operation of the
# pager
class SourceListWidget < Widgeon::Widget
  
  ITEMS_PER_PAGE = 5
  
  def before_render
    raise(ArgumentError, "Source options missing") unless(@source_options)
    @source_options[:page] = @page ? @page : 1    
    @sources = TaliaCore::Source.paginate(@source_options.dup)
  end
  
  
end
