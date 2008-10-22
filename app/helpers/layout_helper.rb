module LayoutHelper
  def title(page_title)
    @content_for_title = if page_title.to_s
      page_title.to_s
    elsif @source
      short_name(@source)
    end
  end

  def subtitle
    @subtitle || "Let's discover what's out there"
  end
  
  # Helper to get the short name of a source
  def short_name(source) 
    assit_kind_of(TaliaCore::Source, source)
    shortname = source.talias::shortname
    if(shortname && shortname.size > 0)
      # get the first short name
      shortname = shortname[0]
    else
      shortname = source.uri.local_name
    end
    
    shortname
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
  
  # Show flash messages.
  def show_flash
    return if flash.empty?

    flash.map do |status, message|
      content_tag(:div, h(message), :id => "flash_#{status}")
    end
  end
  
  # Show the logout box if the user is loggedin.
  # TODO: in future should handle even the login link.
  def login_box
    %(<div id="login_box">#{languages_box} | #{link_to("Logout", logout_path)}</div>) if logged_in?
  end
  
  def languages_box
    select_tag("languages", languages_box_options_tags, :onchange => change_language_function)
  end
  
  def languages_box_options_tags
    languages.map do |language, locale|
      language = language.to_s.titleize
      selected = locale == Locale.active.code
      value = change_language_path(locale)
      content_tag(:option, language, :value => value, :selected => selected)
    end
  end
  
  def change_language_function
    "javascript:window.location.href = this.options[this.selectedIndex].value;"
  end
  
  def javascript(*file_names)
    @content_for_javascript ||= ""
    @content_for_javascript << file_names.map { |fn| javascript_include_tag(fn.to_s) }.join("\n")
  end
  
  def stylesheet(*file_names)
    @content_for_stylesheet ||= ""
    @content_for_stylesheet << file_names.map { |fn| stylesheet_link_tag(fn.to_s, :cache => true) }.join("\n")
  end
end