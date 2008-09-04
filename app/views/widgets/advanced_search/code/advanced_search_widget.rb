# Advanced search box
class AdvancedSearchWidget < Widgeon::Widget
  
  # Initialize the widget
  # * field_1_label => text for first field (default value is 'work')
  # * firld_1 => Array. It contain data for the first combo box (default value is an empty array).
  # * field_2_label => text for first field (default value is 'aphorisms')
  # * firld_2 => Array. It contain data for the second combo box (default value is an empty array).
  # * field_3_label => text for first field (default value is 'through')
  # * firld_3 => Array. It contain data for the third combo box (default value is an empty array).
  #
  # Example:
  # widget(:advanced_search, 
  #        :id => 'search_adv', 
  #        :options => {:field_1_label => 'work',
  #                     :field_1 => ['AC', 'AD', 'AF', 'AG'], 
  #                     :field_2_label => 'aphorisms',
  #                     :field_2 => [6,7,8,9], 
  #                     :field_3_label => 'through',
  #                     :field_3 => [12,20,26,300]})
  def on_init
    unless is_callback?
      widget_session[:field_1_label] = @options[:field_1_label] || 'work'
      widget_session[:field_1] = @options[:field_1] || []
      widget_session[:field_2_label] = @options[:field_2_label] || 'aphorisms'
      widget_session[:field_2] = @options[:field_2] || []
      widget_session[:field_3_label] = @options[:field_3_label] || 'through'
      widget_session[:field_3] = @options[:field_3] || []
    end
  end
  
  # Return the plus button
  def add_link(current_size)
    remote_link('add',{
        :javascript => :add_work_line, 
        :current_size => current_size
      }, {
        :class => "plus"
      })    
  end

  # Return the minus button
  def remove_link(current_size)
    remote_link('remove', { 
        :javascript => :remove_work_line, 
        :current_size => current_size
      }, {
        :class => "minus"
      })
  end
  
  # Callback for plus button
  callback :add_work_line do |page|
    # check if current_size is present
    raise(ArgumentError, "Required argument missing") unless(@current_size)

    # add new row to advanced search
    page.insert_html :before, 
      'src_line_tail', 
      partial(:advanced_search_work, :locals => {
        :current_size => @current_size + 1,
        :field_1_label => widget_session[:field_1_label],
        :field_1 => widget_session[:field_1],
        :field_2_label => widget_session[:field_2_label],
        :field_2 => widget_session[:field_2],
        :field_3_label => widget_session[:field_3_label],
        :field_3 => widget_session[:field_3]
      })
  end
  
  # Callback for minus button
  callback :remove_work_line do |page|
    # check if current_size is present 
    raise(ArgumentError, "Required argument missing") unless(@current_size)

    # add new row to advanced search if current size is > 0
    if @current_size > 0
      page.remove "src_line_#{@current_size}"
    end
  end
  
end