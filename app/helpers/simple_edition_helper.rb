module SimpleEditionHelper
  
  # Insert the toolbar
  def toolbar(tools)
    render(:partial => 'shared/toolbar_item', :collection => tools)
  end
  
  def edition_partial(name)
    render(:partial => "#{@edition_type}_editions/#{name}")
  end
  
  def edition_page_title
    "#{TaliaCore::SITE_NAME} - #{translate_window_title(@edition)}#{@page_title_suff}"
  end

  def translate_window_title(edition)
    title = edition_title(edition)
    t(:"talia.edition.#{title.underscore.downcase}.window_title", false)
  end

  def edition_include_name
    "editions/#{@edition_type}"
  end
  
  def edition_include_custom_name(custom)
    "editions/#{@edition_type}_custom/#{custom}"
  end
  
  def edition_javascript_include
    javascript_include_tag edition_include_name
  end

  def tool_title(tool)
    t(:"talia.tools.#{tool[:text]}", false)
  end

  def tool_text(tool)
    t(:"talia.tools.#{tool[:text]}")
  end
  
  def edition_style_link
    links = ''
    if @custom_edition_stylesheet.nil?
      links << stylesheet_link_tag(edition_include_name)
      links << stylesheet_link_tag("editions/#{@edition.uri.local_name}")
      links << stylesheet_link_tag("editions/#{@edition.uri.local_name}", :media => 'print')
    else
      @custom_edition_stylesheet.each do |custom_style|
        links << stylesheet_link_tag(edition_include_custom_name(custom_style))
      end
    end

    unless @custom_stylesheet.nil?
      @custom_stylesheet.each do |custom_style|
#        links << stylesheet_link_tag(custom_style)
         case custom_style
        when Array
          links << stylesheet_link_tag(custom_style[0], :media => custom_style[1])
        when String
          links << stylesheet_link_tag(custom_style, :media => "all")
        end

      end
    end

    # add print stylesheet if present
    unless @print_stylesheet.nil?
      @print_stylesheet.each do |print_style|
        links << stylesheet_link_tag(edition_include_custom_name(print_style), :media => 'print')
      end
    end

    links
  end
  
  def edition_print_style_link
    links = ''
    @print_stylesheet.each do |print_style|
      links << stylesheet_link_tag(edition_include_custom_name(print_style), :media => 'print')
    end
  end

  def advanced_search_visible
    @advanced_search_visible
  end

end
