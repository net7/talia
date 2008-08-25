# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def header
    render :partial => 'shared/main_header'
  end
  
  def footer
    render :partial => 'shared/main_footer'
  end
  
  def sidebar
    sidebar_title = nil
    sidebar_title = "#{@source.label} is" if(@source)
    widget(:sidebar,
        'active_tab' => 'context',
        'active_tab_options' => { :source => @source },
        'sidebar_title' => sidebar_title
        )
  end
  
  def talia_footer
    %( <div id="footer" class="open">
       <h1>Talia | Discovery</h1>
       <p>Let's discover things</p>
       </div> )
  end
  
  # Returns the title for the whole page. This returns the value
  # set in the controller, or a default value
  def page_title
    if(@page_title)
      @page_title
    elsif(@source)
      short_name(@source)
    else
      "Talia | The Digital Library"
    end 
  end
  
  # Returns the subtitle for the page. See page_title
  def page_subtitle
    @page_subtitle ? @page_subtitle : "Let's discover what's out there"
  end
  
  # Creates a link to the given source
  def source_link(text, source)
    link_to(text, :controller => 'sources', :action => 'show', :id => source.uri.local_name)
  end
  
  def javascript(*file_names)
    file_names.each {|fn| content_for :javascript, javascript_include_tag(fn.to_s)}
    nil
  end
  
  def stylesheet(*file_names)
    file_names.each {|fn| content_for :stylesheet, stylesheet_link_tag(fn.to_s)}
    nil
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
  
  # Returns true if the given property has at least one value on the given
  # Source.
  def has_property?(property)
    property && property.size > 0
  end
  
  # Show each <tt>flash</tt> status (<tt>:notice</tt>, <tt>:error</tt>) only if it's present.
  def show_flash
    [:notice, :error].collect do |status|
      %(<div id="#{status}">#{flash[status]}</div>) unless flash[status].nil?
    end
  end
  
  # Show the logout box if the user is loggedin.
  # TODO: in future should handle even the login link.
  def login_box
    %(<div id="login_box">#{languages_box} | #{link_to("Logout", logout_path)}</div>) if logged_in?
  end
  
  def languages_box
    content_tag(:div, :id => 'languages_box') do
      select_tag("languages", languages_box_options_tags, :onchange => change_language_function)
    end
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
end
