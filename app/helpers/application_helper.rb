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
  
  # Helper to get the labels of the source. This returns an array of labels. 
  # If no label is defined, it will put the local name of the source as the
  # only element.
  def labels(source)
    assit_type(source, TaliaCore::Source)
    labels = source.rdfs::label
    unless(labels && labels.size > 0)
      labels = [source.uri.local_name]
    end
    
    labels
  end
  
  # Helper to get the short name of a source
  def short_name(source) 
    assit_type(source, TaliaCore::Source)
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
  
end
