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
       # set search mode
      widget_session[:mode] = @options[:mode]

      # store work object
      widget_session[:edition] = @options[:edition]

      # reset current size value
      widget_session[:current_size] = 0
     
      # set search mode
      widget_session[:visible] = @options[:visible] || false

      # store label for all field
      widget_session[:field_1_label] = @options[:field_1_label] || 'work'
      widget_session[:field_2_label] = @options[:field_2_label] || 'aphorisms'
      widget_session[:field_3_label] = @options[:field_3_label] || 'through'

      # store search field and type for sophia vision
      widget_session[:search_fields] = @options[:search_fields]
    end
  end

  def visible_style
    if widget_session[:visible]
      "style='display: block;'"
    else
      "style='display: none;'"
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

  # return an hidden field tag for search type
  def tag_search_type
    if is_avmedia_search
      return hidden_field_tag 'search_type', 'media'
    else
      return hidden_field_tag 'search_type', 'mc'
    end
  end

  # return an input tag for words
  def tag_word
    if is_avmedia_search
      raise("Tag not supported in avmedia search")
    else
      return "<label>#{t(:'talia.search.search_phrase_prompt')}</label> <input type='text' name='words' value='#{params[:words]}' />"
    end
  end

  def tag_any_all
    if is_avmedia_search
      raise("Tag not supported in avmedia search")
    else
      # load previous operator used
      case params[:operator]
      when 'or'
        tag_to_check = 'or'
      when 'and'
        tag_to_check = 'and'
      else
        tag_to_check = 'or'
      end

      # create tags
      tag_string = "<input #{"checked" if (tag_to_check == 'or')} type='radio' name='operator' value='or' />"
      tag_string << "<label class='toradio'> #{t(:'talia.search.any')}</label>"
      tag_string << "<input #{"checked" if (tag_to_check == 'and')} type='radio' name='operator' value='and' />"
      tag_string << "<label class='toradio'> #{t(:'talia.search.all')}</label>"

      return tag_string
    end
  end

  # return a select tag for work
  def tag_work
    if is_avmedia_search
      raise("Tag not supported in avmedia search")
    else
      # create tags
      tag_string = "<label>#{t(:"talia.search.#{widget_session[:field_1_label]}")} </label>"
      tag_string << "<select id=\"src_line_#{widget_session[:current_size]}_field_1\" onchange=\"#{onchange_link(widget_session[:current_size])}\" name=\"mc[]\" >"

      works.each do |item|
        unless params[:mc].nil?
          if(params[:mc][widget_session[:current_size]-1] == item)
            selected = true
          end
        end

        tag_string << "<option #{"selected" if selected} value=\"#{item.uri}\">#{item.title}</option>"
      end

      tag_string << "</select>"

      return tag_string
    end
  end

  # return a select tag for aphorisms
  def tag_aphorisms
    if is_avmedia_search
      raise("Tag not supported in avmedia search")
    else
      # load previous mc_from used
      if params[:mc_from].nil?
        selected_value = :first
        selected_mc = works.first.uri
      else
        selected_value = params[:mc_from][widget_session[:current_size]-1]
        selected_mc = params[:mc][widget_session[:current_size]-1]
      end

      # create tags
      tag_string = "<label>#{t(:"talia.search.#{widget_session[:field_2_label]}")} </label>"
      tag_string << w.partial(:advanced_search_select,
        :locals => {:field_name=> 'mc_from[]',
          :current_size => widget_session[:current_size],
          :selected_value => selected_value,
          :data => subparts(selected_mc)})

      return tag_string
    end
  end

  # return a select tag for through
  def tag_through
    if is_avmedia_search
      raise("Tag not supported in avmedia search")
    else
      # load previous mc_from used
      if params[:mc_to].nil?
        selected_value = :last
        selected_mc = works.first.uri
      else
        selected_value = params[:mc_to][widget_session[:current_size]-1]
        selected_mc = params[:mc][widget_session[:current_size]-1]
      end

      # create tags
      tag_string = "<label>#{t(:"talia.search.#{widget_session[:field_3_label]}")} </label>"
      tag_string << w.partial(:advanced_search_select,
        :locals => {:field_name=> 'mc_to[]',
          :current_size => widget_session[:current_size],
          :selected_value => selected_value,
          :data => subparts(selected_mc)})

      return tag_string
    end
  end

  # return a generic select tag with an element selected
  def tag_search_select(field_name, selected_value, current_size = widget_session[:current_size], data = nil)
    if is_avmedia_search
      raise("Tag not supported in avmedia search")
    else
      tag_string = "<select name='#{field_name}' id='#{"src_line_#{current_size}_#{field_name}"}' >"

      unless data.nil?
        data.each_with_index do |item,index|
          case selected_value
          when :first
            is_selected = true if index == 0
          when :last
            is_selected = true if index == (data.size - 1)
          when item[0]
            is_selected = true
          end

          tag_string << "<option #{"selected" if is_selected} value=#{item[0]}>#{item[1]}</option>"
        end
      end

      tag_string << "</select>"

      return tag_string
    end
  end

  # return a select tag for avmedia
  def tag_avmedia_select(field_type = :title_words)
    if !is_avmedia_search
      raise("Tag supported only in avmedia search")
    else
      tag_string = "<select id=\"#{ "src_line_#{widget_session[:current_size]}_field" }\" onchange=\"#{ onchange_link(widget_session[:current_size]) }\">"
      tag_string << "<option #{"selected" if field_type == :title_words} value=\"title\" selected=\"selected\">#{t(:'talia.search.title')}</option>"
      tag_string << "<option #{"selected" if field_type == :abstract_words} value=\"abstract\">#{t(:'talia.search.abstract') }</option>"
      tag_string << "<option #{"selected" if field_type == :keywords} value=\"keyword\">#{t(:'talia.search.keyword')}</option>"
      tag_string << "</select>"

      return tag_string
    end
  end

  # return an input tag for avmedia title words
  def tag_avmedia_title_words(current_size=widget_session[:current_size], value=nil)
    if !is_avmedia_search
      raise("Tag supported only in avmedia search")
    else
      tag_string = "<input type=\"text\" name=\"title_words[]\" id=\"#{"src_line_#{current_size}_field_value"}\" value=\"#{value}\" />"

      return tag_string
    end
  end

  # return an input tag for avmedia abstract words
  def tag_avmedia_abstract_words(current_size=widget_session[:current_size], value=nil)
    if !is_avmedia_search
      raise("Tag supported only in avmedia search")
    else
      tag_string = "<input type=\"text\" name=\"abstract_words[]\" id=\"src_line_#{current_size}_field_value\" value=\"#{value}\" />"

      return tag_string
    end
  end

  # return an input tag for avmedia keywords
  def tag_avmedia_keywords(current_size=widget_session[:current_size], value=nil)
    if !is_avmedia_search
      raise("Tag supported only in avmedia search")
    else
      tag_string = "<select name=\"keywords[]\" id=\"src_line_#{current_size}_field_value\">"
      keyword.each do |item|
        tag_string << "<option #{"selected" if item == value} value='#{item}'>#{item}</option>"
      end
      tag_string << "</select>"
    end

    return tag_string
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
    if !is_avmedia_search
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
          :call_options =>  WidgeonEncoding.encode_options({:javascript => 'retrieve_avmedia_content',
              :current_size => current_size,
              :widget_class => self.class.widget_name,
              :widget_id => self.widget_id})})
    end
  end

  # return an array of all work (for example: TaliaCore::Book)
  def works
    # get current edition
    edition = TaliaCore::CriticalEdition.find widget_session[:edition]

    # return all books in current edition
    return edition.books
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
        title = subpart.dcns.title
        if (title.empty?)
          title = subpart.uri.local_name
        end

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

  def add_work_line
    # increment current_size
    widget_session[:current_size] += 1

    # add new row to advanced search
    partial(:advanced_search_work, :locals => {
        :current_size => widget_session[:current_size],
        :field_1_label => widget_session[:field_1_label],
        :field_2_label => widget_session[:field_2_label],
        :field_3_label => widget_session[:field_3_label]
      })    
  end

  def add_avmedia_generic_row(field_type = nil, field_value = nil)
    # increment current_size
    widget_session[:current_size] += 1

    # add new row to advanced search
    partial(:advanced_search_avmedia_row, :locals => {:current_size => widget_session[:current_size], :field_type => field_type, :field_value => field_value})
  end

  # callback for plus button
  callback :add_work_line do |page|
    # add new row to advanced search
    page.insert_html :before,
      'src_line_tail',
      self.add_work_line
  end

  # callback for plus button for AvMedia
  callback :add_avmedia_generic_row do |page|
    # add new row to advanced search
    page.insert_html :before,
      'src_line_tail',
      self.add_avmedia_generic_row
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
    raise(ArgumentError, "Required argument missing") unless(current_size)

    # get book uri
    book_uri = params["src_line_#{current_size}_field_1_value"]

    # get subparts
    subparts = subparts(book_uri)

    # replace select field 2
    page.replace "src_line_#{current_size}_mc_from[]", partial(:advanced_search_select,
      :locals => {:field_name=> 'mc_from[]',
        :current_size => @current_size,
        :selected_value => :first,
        :data => subparts})

    # replace select field 3
    page.replace "src_line_#{current_size}_mc_to[]", partial(:advanced_search_select,
      :locals => {:field_name=> 'mc_to[]',
        :current_size => @current_size,
        :selected_value => :last,
        :data => subparts})
  end

  # retrieve subparts contained in current work
  callback :retrieve_avmedia_content do |page|
    # check if current_size is present
    raise(ArgumentError, "Required argument missing") unless(@current_size)

    # replace current field tag with new field tag
    new_object = ""
    case params["src_line_#{@current_size}_field"]
    when "title"
      new_object << tag_avmedia_title_words(@current_size)
    when "abstract"
      new_object << tag_avmedia_abstract_words(@current_size)
    when "keyword"
      new_object << tag_avmedia_keywords(@current_size)
    end

    # replace field
    page.replace "src_line_#{@current_size}_field_value", new_object

  end

  def is_avmedia_search
    return (widget_session[:mode] == :avmedia)
  end

end
