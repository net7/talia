# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
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
end
