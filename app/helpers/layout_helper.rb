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
      'widget_id' => 'main',
      'html_options' => { :class => 'open' },
      'sidebar_title' => sidebar_title
  end
  
  def types_sidebar
    hide_sources_sidebar
    @content_for_sidebar = widget :sidebar, 
      'active_tab' => 'navigation',
      'active_tab_options' => { :source_class => @type },
      'widget_id' => 'main',
      'html_options' => { :class => 'open' }
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

  # Always send those contents, even if the user is *not* logged in.
  # This is *very helpful* for caches purposes, since we should handle page
  # expirations for each login/logout, only for show/hide this box.
  #
  # Since the box doesn't contains sensible data, we can always safely send it
  # and let javascript decide to show or hide it.
  #
  # Scenario 1: User login
  #   The login process send a cookie on each page load, javascript look
  #   at that value and show the box.
  # Scenario 2: User not logged in
  #   The cookie is not set or is false, so javascript doesn't show the box.
  #
  #
  # NOTE: don't delete display:none, unless you're full understanding the problem.
  def login_box
    %(<div id="login_box" style="display:none;">#{languages_box} | #{link_to("Logout", logout_path)}</div>)
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