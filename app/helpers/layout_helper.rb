module LayoutHelper
  def title(page_title)
    @content_for_title = if page_title.to_s
      page_title.to_s
    elsif @source
      short_name(@source)
    end
  end

  def page_subtitle
    @page_subtitle || "Let's discover what's out there"
  end
  
  def sidebar
    return if hidden_sidebar?
    sidebar_title = "#{@source.label} is" if @source
    @content_for_sidebar = widget :sidebar, 'active_tab' => 'context',
      'active_tab_options' => { :source => @source },
      'sidebar_title' => sidebar_title
  end
  
  def types_sidebar
    hide_sources_sidebar
    @content_for_sidebar = widget :sidebar, 
      'active_tab' => 'navigation',
      'active_tab_options' => { :source_class => @type }
  end
  
  def hide_sidebar
    @hidden_sidebar = true
  end
  alias_method :hide_sources_sidebar, :hide_sidebar
  
  def hidden_sidebar?
    !!@hidden_sidebar
  end
  
  def javascript(*file_names)
    @content_for_javascript ||= ""
    @content_for_javascript << file_names.map { |fn| javascript_include_tag(fn.to_s, :cache => true) }.join("\n")
  end
  
  def stylesheet(*file_names)
    @content_for_stylesheet ||= ""
    @content_for_stylesheet << file_names.map { |fn| stylesheet_link_tag(fn.to_s, :cache => true) }.join("\n")
  end
end