# Advanced search box
class AdvancedSearchWidget < Widgeon::Widget
  
  # Initialize the widget
  # * work => work object, for example TaliaCore::Book
  # * field_1_label => text for first field (default value is 'work')
  # * field_2_label => text for first field (default value is 'aphorisms')
  # * field_3_label => text for first field (default value is 'through')
  # * visible => boolean. Initial visible value.
  # 
  # Example:
  # widget(:advanced_search, 
  #        :id => 'search_adv', 
  #        :options => {:work => @critical_edition.books,
  #                     :field_1_label => 'work',
  #                     :field_2_label => 'aphorisms',
  #                     :field_3_label => 'through',
  #                     :visible => false})
  def on_init
    unless is_callback?
      # store work object
      widget_session[:work] = @options[:work] || nil
      
      # reset current size value
      widget_session[:current_size] = 0
      
      # store label for all field
      widget_session[:field_1_label] = @options[:field_1_label] || 'work'
      widget_session[:field_2_label] = @options[:field_2_label] || 'aphorisms'
      widget_session[:field_3_label] = @options[:field_3_label] || 'through'
    
      # store search field and type for sophia vision
      widget_session[:search_fields] = @options[:search_fields]
    end
  end
  
  # Return a plus button
  def plus_link(current_size, version="default")
    if version == "default"
      remote_link('add',{
          :javascript => :add_work_line, 
          :current_size => current_size
        }, {
          :class => "plus"
        })
    else
      remote_link('add',{
          :javascript => :add_avmedia_generic_row, 
          :current_size => current_size
        }, {
          :class => "plus"
        })
    end
  end

  # Return a minus button
  def minus_link(current_size)
    if current_size > 0
      remote_link('remove', { 
          :javascript => :remove_work_line, 
          :current_size => current_size
        }, {
          :class => "minus"
        })
    else
      remote_link('hide', { 
          :javascript => :hide_search_adv, 
          :current_size => current_size
        }, {
          :class => "minus"
        })
    end
  end
  
  # return onchange link for work field
  def onchange_link(current_size, version="default")
    if version == "default"
      remote_function(:with => "'src_line_#{current_size}_field_1_value=' + $F('src_line_#{current_size}_field_1')",
        :url => {:controller => "widgeon", 
          :action => "callback", 
          :call_options =>  WidgeonEncoding.encode_options({:javascript => 'retrieve_work_content', 
              :current_size => current_size, 
              :widget_class => self.class.widget_name,
              :widget_id => self.widget_id})})
    else
      remote_function(:with => "'src_line_#{current_size}_field=' + $F('src_line_#{current_size}_field')",
        :url => {:controller => "widgeon", 
          :action => "callback",
          :call_options =>  WidgeonEncoding.encode_options({:javascript => 'retrieve_keyword_content', 
              :current_size => current_size, 
              :widget_class => self.class.widget_name,
              :widget_id => self.widget_id})})      
    end
  end
  
  # return an array of all work (for example: TaliaCore::Book)
  def works
    widget_session[:work]
  end
  
  # return an array of all subparts contained in current work.
  # * uri: String. Current work URI.
  def subparts(uri)
    # get book from uri
    book = TaliaCore::Source.find(uri)
    # get book's subparts
    subparts = book.subparts_with_manifestations(N::HYPER.HyperEdition)
    
    # create an array with uri and title for each subpart
    unless subparts.nil?
      # get subpart title
      subparts.collect! do |subpart|
        # get title
        title = subpart.dcns.title.empty? ? subpart.uri.local_name : subpart.dcns.title
        # create array
        [subpart.uri.to_s, title]
      end
    end
    
    # return subparts array
    subparts
  end
  
  def keyword
    TaliaCore::Keyword.find(:all).collect do |item| 
      item.keyword_value
    end
  end
  
  # callback for plus button
  callback :add_work_line do |page|
    # check if current_size is present
    raise(ArgumentError, "Required argument missing") unless(@current_size)

    # increment current_size
    widget_session[:current_size] += 1

    
    # add new row to advanced search
    page.insert_html :before, 
      'src_line_tail', 
      partial(:advanced_search_work, :locals => {
        :current_size => widget_session[:current_size],
        :field_1_label => widget_session[:field_1_label],
        :field_2_label => widget_session[:field_2_label],
        :field_3_label => widget_session[:field_3_label]
      })
  end
  
  # callback for plus button for AvMedia
  callback :add_avmedia_generic_row do |page|
    # check if current_size is present
    raise(ArgumentError, "Required argument missing") unless(@current_size)

    # increment current_size
    widget_session[:current_size] += 1

    # add new row to advanced search
    page.insert_html :before, 
      'src_line_tail', 
      partial(:advanced_search_avmedia_row, :locals => {:current_size => widget_session[:current_size], :keyword_list => keyword})
  end
  
  # callback for minus button
  callback :remove_work_line do |page|
    # check if current_size is present 
    raise(ArgumentError, "Required argument missing") unless(@current_size)

    # add new row to advanced search if current size is > 0
    if @current_size > 0
      page.remove "src_line_#{@current_size}"
    end
  end
  
  # hide advanced search div
  callback :hide_search_adv do |page|
    page.hide 'search_adv'
  end
  
  # retrieve subparts contained in current work
  callback :retrieve_work_content do |page|
    # check if current_size is present 
    raise(ArgumentError, "Required argument missing") unless(@current_size)

    # get book uri
    book_uri = params["src_line_#{@current_size}_field_1_value"]

    # get subparts
    subparts = subparts(book_uri)
    
    # replace select field 2
    page.replace "src_line_#{current_size}_mc_from[]", partial(:advanced_search_select, 
      :locals => {:field_name=> 'mc_from[]', 
        :current_size => @current_size,
        :selected_index => :first,
        :data => subparts})

    # replace select field 3
    page.replace "src_line_#{current_size}_mc_to[]", partial(:advanced_search_select, 
      :locals => {:field_name=> 'mc_to[]', 
        :current_size => @current_size, 
        :selected_index => :last,
        :data => subparts})
  end
  
  # retrieve subparts contained in current work
  callback :retrieve_keyword_content do |page|
    # check if current_size is present 
    raise(ArgumentError, "Required argument missing") unless(@current_size)

    # if parameter is keyword, replace it with combobox
    new_object = ""
    case params["src_line_#{@current_size}_field"]
    when "title"
      new_object << "<input type='text' name='title_words[]' id='src_line_#{current_size}_field_value' />"
    when "abstract"
      new_object << "<input type='text' name='abstract_words[]' id='src_line_#{current_size}_field_value' />"
    when "keyword"
      new_object << "<select name='keywords[]' id='src_line_#{current_size}_field_value'>"
      keyword.each do |item|
        new_object << "<option value='#{item}'>#{item}</option>"
      end
      new_object << "</select>"
    end
        
    # replace textbox with combobox
    page.replace "src_line_#{current_size}_field_value", new_object

  end
  
end
