# Advanced search box
class AdvancedSearchWidget < Widgeon::Widget
  
  # Initialize the widget
  # * servlet => string. Servelet URL
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
      widget_session[:work] = @options[:work]
      
      # reset current size value
      widget_session[:current_size] = 0
      
      # store label for all field
      widget_session[:field_1_label] = @options[:field_1_label] || 'work'
      widget_session[:field_2_label] = @options[:field_2_label] || 'aphorisms'
      widget_session[:field_3_label] = @options[:field_3_label] || 'through'
      
    end
  end
  
  # Return a plus button
  def plus_link(current_size)
    remote_link('add',{
        :javascript => :add_work_line, 
        :current_size => current_size
      }, {
        :class => "plus"
      })
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
  def onchange_link(current_size)
   remote_function(:with => "'src_line_#{current_size}_field_1_value=' + $F('src_line_#{current_size}_field_1')",
      :url => {:controller => "widgeon", 
        :action => "callback", 
        :call_options =>  WidgeonEncoding.encode_options({:javascript => 'retrieve_work_content', 
            :current_size => current_size, 
            :widget_class => self.class.widget_name,
            :widget_id => self.widget_id})})
  end
  
  # return an array of all work (for example: TaliaCore::Book)
  def works
    widget_session[:work]
  end
  
  # return an array of all paragraphs contained in current work.
  # * uri: String. Current work URI.
  def paragraphs(uri)
    # get book from uri
    book = TaliaCore::Source.find(uri)
    # get book's paragraphs
    paragraphs = book.subparts_with_manifestations(N::HYPER.HyperEdition, N::HYPER.Paragraph)
    
    # create an array with uri and title for each paragraph
    unless paragraphs.nil?
      # get paragraph title
      paragraphs.collect! do |paragraph| 
        # get title
        title = paragraph.dcns.title.empty? ? paragraph.uri.local_name : paragraph.dcns.title
        # create array
        [paragraph.uri.to_s, title]
      end
    end
    
    # return paragraphs array
    paragraphs
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
  
  # retrieve paragraphs contained in current work
  callback :retrieve_work_content do |page|
    # check if current_size is present 
    raise(ArgumentError, "Required argument missing") unless(@current_size)

    # get book uri
    book_uri = params["src_line_#{@current_size}_field_1_value"]

    # get paragraphs
    paragraphs = paragraphs(book_uri)
    
    # replace select field 2
    page.replace "src_line_#{current_size}_mc_from[]", partial(:advanced_search_select, 
      :locals => {:field_name=> 'mc_from[]', 
        :current_size => @current_size,
        :selected_index => :first,
        :data => paragraphs})

    # replace select field 3
    page.replace "src_line_#{current_size}_mc_to[]", partial(:advanced_search_select, 
      :locals => {:field_name=> 'mc_to[]', 
        :current_size => @current_size, 
        :selected_index => :last,
        :data => paragraphs})
  end
  
  callback :advanced_search_succeed do |page|
    
    puts "aaaaa"
    
  end
  
end