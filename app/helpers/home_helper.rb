module HomeHelper
  
  def select_language(name, locale)
    link_to(name, { :controller => 'languages', :action => 'change', :id => locale })
  end
  
  def render_home(options)
    render :partial => 'start_template', :locals => {
      :title_links => options[:title_links],
      :languages => options[:languages],
      :footer_link => options[:footer_link]
    }
  end
  
  # Puts a list of links to all editions of the given type
  def edition_links(type)
    render(:partial => 'edition', :collection => @editions[type]) if(@editions && @editions[type])
  end
  
  # Puts the category links for the AvEdition
  def category_links
    render(:partial => 'category', :collection => @editions[:categories])
  end
  
  # Puts the series links for the AvEdition
  def series_links
    render(:partial => 'series', :collection => @editions[:series])
  end
  
  # The edition prefix for the given edition
  def prefix_for(edition)
    edition.class::EDITION_PREFIX
  end

    # Create a locale-sensitve URL by replacing "LANG" in the current string with
  # the current language code
  def locale_uri(string)
    string.gsub(/LANG/, Locale.language_code)
  end
  
end
