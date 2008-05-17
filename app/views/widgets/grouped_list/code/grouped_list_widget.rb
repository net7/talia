# Displays a paginated list of sources, using the widgeon will_paginate support.
# This takes the following options:
# 
# * <tt>source_options</tt> - A hash of options that will be passed to 
#                             TaliaCore::Source#paginate to retrieve 
#                             the sources. A page parameter will be silently ignored.
# * <tt>page</tt> - The current page of the pagination. If this is not given, 
#                   the first page is shown.
class GroupedListWidget < Widgeon::Widget
  
  def on_init
    @snippet_dir ||= 'source_list'
    setup_standard unless(is_callback?) # For the callback we don't need to init
    raise(ArgumentError, "Property must be given for grouping") unless(@group_property)
    raise(ArgumentError, "Group increment must be given") unless(@group_increment)
  end
  
  # This iterates through all the groups in the source list, passing 
  # two parameters: First, the group name as a string and a collection of
  # elements with the group members
  def groups
    @groups.each do |group, elements|
      yield(group, elements)
    end
  end
  
  def more_link(element, current_size = nil)
    current_size ||= @groups[element].size
    @type_count ||= {}
    @type_count[element] ||= TaliaCore::Source.count(@group_property => element)
    return '' unless(@type_count[element] > current_size)
    
    link = '<div class="list_more" id="' << element_name(element) << '_more">'
    link << remote_link('[more]', { :javascript => 'grow_list', 
      :group_id => element_name(element), 
      :current_size => current_size, 
      :group_increment => @group_increment,
      :group_property => @group_property,
      :snippet_dir => @snippet_dir,
      :fallback => { :id => element_name(element) } }
      )
    link << '</div>'
  end
  
  # Callback to grow a list element
  callback :grow_list do |page|
    raise(ArgumentError, "Required argument missing") unless(@group_id && @current_size)
    my_property = N::URI.make_uri(@group_id, '_', '')
    new_items = TaliaCore::Source.find(:all, @group_property => my_property, :offset => @current_size, :limit => @group_increment)
    
    # The insert is a bit involved since: 
    # * The more link will be updated with a correct version for the next increment
    # * The new elements will be loaded into a div with an id, so that we
    # * can slide it in with scriptaculous.
    new_size = @current_size + new_items.size
    inc_id = element_name(my_property) + new_size.to_s # id for the newly inserted items
    more_id = @group_id + '_more' # id for the [more] div
    
    item_html = create_list_increment(new_items, inc_id)
    new_more = more_link(my_property, new_size)
    
    page.insert_html(:before, more_id, :inline => item_html) # insert new things first
    page.replace(more_id, :inline => new_more) # this may replace with an empty element
    
    page.hide(inc_id)
    page.visual_effect(:blind_down, inc_id)
  end
  
  private
  
    # Creates a new div to increment the list
  def create_list_increment(items, id)
    increment = '<div id="' << id << '">'
    increment << partial('source_item', :collection => items)
    increment << '</div>'
  end
  
  # Gives a string representation of an element that is a String or an N::URI
  def element_name(element)
    element.is_a?(N::URI) ? element.to_name_s('_') : element
  end
  
  # Setup for standard rendering (no callback)
  def setup_standard
    raise(ArgumentError, "A list of values must be given") unless(@group_values)
    @groups = TaliaCore::Source.groups_by_property(@group_property, @group_values, :limit => @group_increment.to_i)
  end
  
end
